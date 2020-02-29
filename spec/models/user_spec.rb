# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it do
      should have_many(:access_grants)
               .class_name('Doorkeeper::AccessGrant')
               .with_foreign_key(:resource_owner_id)
               .dependent(:delete_all)
    end

    it do
      should have_many(:access_tokens)
               .class_name('Doorkeeper::AccessToken')
               .with_foreign_key(:resource_owner_id)
               .dependent(:delete_all)
    end

    it do
      should have_one(:recent_access_token)
               .class_name('Doorkeeper::AccessToken')
               .dependent(:delete)
               .order(id: :desc)
    end

    it { should have_one(:student).dependent(:destroy) }

    it do
      should have_many(:reported_bugs)
               .class_name('BugReport')
               .inverse_of(:reporter)
               .dependent(:delete_all)
    end

    it do
      should have_many(:reported_abuses)
               .class_name('AbuseReport')
               .inverse_of(:reporter)
               .with_foreign_key(:reporter_id)
               .dependent(:destroy)
    end

    it do
      should have_one(:abuse_report)
               .inverse_of(:user)
               .with_foreign_key(:user_id)
               .dependent(:destroy)

      should have_many(:uploads)
               .dependent(:destroy)
               .class_name('Attachment')
               .inverse_of(:author)
    end

    it { should have_many(:identities).dependent(:destroy) }

    it do
      should have_many(:audit_events)
               .with_foreign_key(:author_id)
               .dependent(:delete_all)
    end

    it do
      should have_many(:activity_events)
               .with_foreign_key(:author_id)
               .dependent(:delete_all)
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }

    it { should validate_uniqueness_of(:username) }
  end

  describe 'user creation' do
    let_it_be(:user) { create(:user, username: 'wat_user') }

    it { expect(user.admin?).to be_falsey }

    it { expect(user.banned_at).to be_nil }
  end

  describe 'scopes' do
    describe '.by_username' do
      it 'finds users regardless of the case passed' do
        camel_user = create(:user, username: 'CaMeLcAsEd')
        upper_user = create(:user, username: 'UPPERCASE')

        result = described_class.by_username(%w[CAMELCASED uppercase])

        expect(result).to contain_exactly(camel_user, upper_user)
      end

      it 'finds a single user regardless of the case passed' do
        user = create(:user, username: 'CaMeLcAsEd')

        expect(described_class.by_username('CAMELCASED')).to contain_exactly(user)
      end
    end

    describe '.admins' do
      let_it_be(:user) { create(:user) }

      it 'returns only user with admin privileges' do
        admin = create(:admin)

        expect(described_class.admins).to eq([admin])
      end

      it 'returns nothing if admins not present' do
        expect(described_class.admins).to eq([])
      end
    end

    describe '.banned' do
      let_it_be(:user) { create(:user) }

      it 'returns only banned users' do
        banned_user = create(:user, banned_at: Time.now)

        expect(described_class.banned).to eq([banned_user])
      end

      it 'returns nothing if banned user not present' do
        expect(described_class.banned).to eq([])
      end
    end

    describe '.active' do
      let_it_be(:banned_user) { create(:user, banned_at: Time.now) }

      it 'returns only active users' do
        active_user = create(:user)

        expect(described_class.active).to eq([active_user])
      end

      it 'returns nothing if active user not present' do
        expect(described_class.active).to eq([])
      end
    end

    describe '.confirmed' do
      let_it_be(:unconfirmed_user) { create(:user, confirmed_at: nil) }

      it 'returns only user confirmed users' do
        user = create(:user)

        expect(described_class.confirmed).to eq([user])
      end

      it 'returns nothing if confirmed user not present' do
        expect(described_class.confirmed).to eq([])
      end
    end
  end

  describe '.filter' do
    let_it_be(:user) { double }

    it 'filters by active users by default' do
      expect(described_class).to receive(:active).and_return([user])

      expect(described_class.filter(nil)).to include(user)
    end

    it 'filters by admins' do
      expect(described_class).to receive(:admins).and_return([user])

      expect(described_class.filter('admins')).to include(user)
    end

    it 'filters by banned' do
      expect(described_class).to receive(:banned).and_return([user])

      expect(described_class.filter('banned')).to include(user)
    end
  end

  describe '.find_for_database_authentication' do
    it 'strips whitespace from login' do
      user = create(:user)

      expect(described_class.find_for_database_authentication(login: " #{user.username} ")).to eq user
    end
  end

  describe '.by_login' do
    let_it_be(:username) { 'John' }
    let_it_be(:user) { create(:user, username: username) }

    it 'finds user by email' do
      expect(described_class.by_login(user.email)).to eq(user)
    end

    it 'finds user by upcase email match' do
      expect(described_class.by_login(user.email.upcase)).to eq(user)
    end

    it 'finds user by username match' do
      expect(described_class.by_login(username)).to eq (user)
    end

    it 'finds user by username lowercase' do
      expect(described_class.by_login(username.downcase)).to eq(user)
    end

    it 'returns nil on nil login' do
      expect(described_class.by_login(nil)).to be_nil
    end

    it 'returns nil on empty login string' do
      expect(described_class.by_login('')).to be_nil
    end
  end

  context 'user availability' do
    let_it_be(:user) { build_stubbed(:user, banned_at: '2019-08-09') }
    describe '#banned?' do
      subject { user.banned? }

      it { is_expected.to be(true) }
    end

    describe '#active?' do
      subject { user.active? }

      it { is_expected.to be(false) }
    end
  end

  describe '.search' do
    subject { described_class.search(query) }

    context 'when user without profile' do
      let_it_be(:user) { create(:user, username: 'watusername', email: 'email@example.com') }

      context 'with a matching email' do
        let(:query) { user.email }

        it { is_expected.to eq([user]) }
      end

      context 'with a partially matching email' do
        let(:query) { user.email[0..2] }

        it { is_expected.to eq([user]) }
      end

      context 'with a matching email regardless of the casting' do
        let(:query) { user.email.upcase }

        it { is_expected.to eq([user]) }
      end

      context 'with a matching username' do
        let(:query) { user.username }

        it { is_expected.to eq([user]) }
      end

      context 'with a partially matching username' do
        let(:query) { user.username[0..2] }

        it { is_expected.to eq([user]) }
      end

      context 'with a matching username regardless of the casting' do
        let(:query) { user.username.upcase }

        it { is_expected.to eq([user]) }
      end

      context 'with a blank query' do
        let(:query) { '' }

        it { is_expected.to eq([]) }
      end
    end
  end
end
