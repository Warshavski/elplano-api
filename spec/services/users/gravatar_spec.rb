require 'rails_helper'

describe Users::Gravatar do
  describe '#generate' do
    subject { described_class.new }

    let(:url) { 'http://example.com/avatar?hash=%{hash}&size=%{size}&email=%{email}&username=%{username}' }

    before do
      allow(subject).to receive(:gravatar_config).and_return('plain_url' => url)
    end

    it 'replaces the placeholders' do
      avatar_url = subject.generate('wat@so.yeah', 100, 2, username: 'user')

      inclusions = %W[
          hash=#{Digest::MD5.hexdigest('wat@so.yeah')}
          size=200
          email=wat%40so.yeah
          username=user
        ]

      inclusions.each { |expectation| expect(avatar_url).to include(expectation) }
    end
  end
end
