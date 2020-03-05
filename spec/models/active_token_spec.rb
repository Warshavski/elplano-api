# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveToken, :clean_elplano_redis_sessions do
  let_it_be(:user) do
    create(:user).tap do |user|
      user.current_sign_in_at = Time.current
    end
  end

  let(:token) do
    '6919a6f1bb119dd7396fadc38fd18d0d'
  end

  let(:request) do
    double(
      :request,
      {
        user_agent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 8_1_3 like Mac OS X) AppleWebKit/600.1.4 ' \
        '(KHTML, like Gecko) Mobile/12B466 [FBDV/iPhone7,2]',
        ip: '127.0.0.1'
      }
    )
  end

  describe '.list' do
    it 'returns all sessions by user' do
      Elplano::Redis::Sessions.with do |redis|
        redis.set("session:elplano:#{user.id}:6919a6f1bb119dd7396fadc38fd18d0d", Marshal.dump({ token: 'a' }))
        redis.set("session:elplano:#{user.id}:59822c7d9fcdfa03725eff41782ad97d", Marshal.dump({ token: 'b' }))
        redis.set("session:elplano:9999:5c8611e4f9c69645ad1a1492f4131358", '')

        redis.sadd(
          "session:lookup:user:elplano:#{user.id}",
          %w[
            6919a6f1bb119dd7396fadc38fd18d0d
            59822c7d9fcdfa03725eff41782ad97d
          ]
        )
      end

      expect(ActiveToken.list(user)).to match_array [{ token: 'a' }, { token: 'b' }]
    end

    it 'does not return obsolete entries and cleans them up' do
      Elplano::Redis::Sessions.with do |redis|
        redis.set("session:elplano:#{user.id}:6919a6f1bb119dd7396fadc38fd18d0d", Marshal.dump({ token: 'a' }))

        redis.sadd(
          "session:lookup:user:elplano:#{user.id}",
          %w[
            6919a6f1bb119dd7396fadc38fd18d0d
            59822c7d9fcdfa03725eff41782ad97d
          ]
        )
      end

      expect(ActiveToken.list(user)).to eq [{ token: 'a' }]

      Elplano::Redis::Sessions.with do |redis|
        actual_result = redis.sscan_each("session:lookup:user:elplano:#{user.id}").to_a

        expect(actual_result).to(eq(['6919a6f1bb119dd7396fadc38fd18d0d']))
      end
    end

    it 'returns an empty array if the use does not have any active session' do
      expect(ActiveToken.list(user)).to eq []
    end
  end

  describe '.set' do
    subject { described_class.set(user, token, request) }

    it 'sets a new redis entry for the user session and a lookup entry' do
      expected_results = %W[
        session:elplano:#{user.id}:#{token}
        session:lookup:user:elplano:#{user.id}
      ]

      subject

      Elplano::Redis::Sessions.with do |redis|
        expect(redis.scan_each.to_a).to match_array(expected_results)
      end
    end

    it 'adds timestamps and information from the request' do
      current_time = Time.zone.parse('2020-03-04 22:22')

      Timecop.freeze(current_time) do
        subject

        session = ActiveToken.list(user)

        expect(session.count).to eq 1
        expect(session.first).to have_attributes(
          ip_address: '127.0.0.1',
          browser: 'Mobile Safari',
          os: 'iOS',
          device_name: 'iPhone 6',
          device_type: 'smartphone',
          created_at: user.current_sign_in_at,
          updated_at: current_time
        )
      end
    end

    it 'keeps the created_at from the login on consecutive requests' do
      now = Time.zone.parse('2020-03-04 22:22')

      Timecop.freeze(now) do
        subject

        Timecop.freeze(now + 1.minute) do
          subject

          session = ActiveToken.list(user)

          expect(session.first).to(
            have_attributes(created_at: user.current_sign_in_at)
          )
        end
      end
    end
  end

  describe '.destroy' do
    subject { ActiveToken.destroy(user, token) }

    it 'removes the entry associated with the currently killed user session' do
      Elplano::Redis::Sessions.with do |redis|
        redis.set("session:elplano:#{user.id}:6919a6f1bb119dd7396fadc38fd18d0d", '')
        redis.set("session:elplano:#{user.id}:59822c7d9fcdfa03725eff41782ad97d", '')
        redis.set("session:elplano:9999:5c8611e4f9c69645ad1a1492f4131358", '')
      end

      subject

      Elplano::Redis::Sessions.with do |redis|
        expected_result = %W[
          session:elplano:#{user.id}:59822c7d9fcdfa03725eff41782ad97d
          session:elplano:9999:5c8611e4f9c69645ad1a1492f4131358
        ]

        expect(redis.scan_each(match: "session:elplano:*")).to match_array(expected_result)
      end
    end

    it 'removes the lookup entry' do
      Elplano::Redis::Sessions.with do |redis|
        redis.set("session:elplano:#{user.id}:6919a6f1bb119dd7396fadc38fd18d0d", '')
        redis.sadd("session:lookup:user:elplano:#{user.id}", '6919a6f1bb119dd7396fadc38fd18d0d')
      end

      subject

      Elplano::Redis::Sessions.with do |redis|
        expect(redis.scan_each(match: "session:lookup:user:elplano:#{user.id}").to_a).to be_empty
      end
    end

    it 'removes the devise session' do
      Elplano::Redis::Sessions.with do |redis|
        redis.set("session:elplano:#{user.id}:6919a6f1bb119dd7396fadc38fd18d0d", '')
        redis.set("session:elplano:6919a6f1bb119dd7396fadc38fd18d0d", '')
      end

      subject

      Elplano::Redis::Sessions.with do |redis|
        expect(redis.scan_each(match: "session:elplano:*").to_a).to be_empty
      end
    end
  end

  describe '.cleanup' do
    before do
      stub_const("ActiveToken::ACTIVE_TOKENS_LIMIT", 5)
    end

    subject { ActiveToken.cleanup(user) }

    it 'removes obsolete lookup entries' do
      Elplano::Redis::Sessions.with do |redis|
        redis.set("session:elplano:#{user.id}:6919a6f1bb119dd7396fadc38fd18d0d", '')
        redis.sadd("session:lookup:user:elplano:#{user.id}", '6919a6f1bb119dd7396fadc38fd18d0d')
        redis.sadd("session:lookup:user:elplano:#{user.id}", '59822c7d9fcdfa03725eff41782ad97d')
      end

      subject

      Elplano::Redis::Sessions.with do |redis|
        expect(redis.smembers("session:lookup:user:elplano:#{user.id}")).to eq ['6919a6f1bb119dd7396fadc38fd18d0d']
      end
    end

    it 'does not bail if there are no lookup entries' do
      subject
    end

    context 'cleaning up old sessions' do
      let(:max_number_of_sessions_plus_one) { ActiveToken::ACTIVE_TOKENS_LIMIT + 1 }
      let(:max_number_of_sessions_plus_two) { ActiveToken::ACTIVE_TOKENS_LIMIT + 2 }

      before do
        Elplano::Redis::Sessions.with do |redis|
          (1..max_number_of_sessions_plus_two).each do |number|
            redis.set(
              "session:elplano:#{user.id}:#{number}",
              Marshal.dump(ActiveToken.new(token: "#{number}", updated_at: number.days.ago))
            )
            redis.sadd(
              "session:lookup:user:elplano:#{user.id}",
              "#{number}"
            )
          end
        end
      end

      it 'removes obsolete active sessions entries' do
        subject

        Elplano::Redis::Sessions.with do |redis|
          sessions = redis.scan_each(match: "session:elplano:#{user.id}:*").to_a

          expect(sessions.count).to eq(ActiveToken::ACTIVE_TOKENS_LIMIT)
          expect(sessions).not_to(
            include(
              "session:elplano:#{user.id}:#{max_number_of_sessions_plus_one}",
              "session:elplano:#{user.id}:#{max_number_of_sessions_plus_two}"
            )
          )
        end
      end

      it 'removes obsolete lookup entries' do
        subject

        Elplano::Redis::Sessions.with do |redis|
          lookup_entries = redis.smembers("session:lookup:user:elplano:#{user.id}")

          expect(lookup_entries.count).to eq(ActiveToken::ACTIVE_TOKENS_LIMIT)
          expect(lookup_entries).not_to(
            include(max_number_of_sessions_plus_one.to_s, max_number_of_sessions_plus_two.to_s)
          )
        end
      end

      it 'removes obsolete lookup entries even without active session' do
        Elplano::Redis::Sessions.with do |redis|
          redis.sadd(
            "session:lookup:user:elplano:#{user.id}",
            "#{max_number_of_sessions_plus_two + 1}"
          )
        end

        subject

        Elplano::Redis::Sessions.with do |redis|
          lookup_entries = redis.smembers("session:lookup:user:elplano:#{user.id}")

          expect(lookup_entries.count).to eq(ActiveToken::ACTIVE_TOKENS_LIMIT)
          expect(lookup_entries).not_to include(
            max_number_of_sessions_plus_one.to_s,
            max_number_of_sessions_plus_two.to_s,
            (max_number_of_sessions_plus_two + 1).to_s
          )
        end
      end

      context 'when the number of active sessions is lower than the limit' do
        before do
          Elplano::Redis::Sessions.with do |redis|
            ((max_number_of_sessions_plus_two - 4)..max_number_of_sessions_plus_two).each do |number|
              redis.del("session:elplano:#{user.id}:#{number}")
            end
          end
        end

        it 'does not remove active session entries, but removes lookup entries' do
          lookup_entries_before_cleanup = Elplano::Redis::Sessions.with do |redis|
            redis.smembers("session:lookup:user:elplano:#{user.id}")
          end

          sessions_before_cleanup = Elplano::Redis::Sessions.with do |redis|
            redis.scan_each(match: "session:elplano:#{user.id}:*").to_a
          end

          subject

          Elplano::Redis::Sessions.with do |redis|
            lookup_entries = redis.smembers("session:lookup:user:elplano:#{user.id}")
            sessions = redis.scan_each(match: "session:elplano:#{user.id}:*").to_a
            expect(sessions.count).to eq(sessions_before_cleanup.count)
            expect(lookup_entries.count).to be < lookup_entries_before_cleanup.count
          end
        end
      end
    end
  end
end
