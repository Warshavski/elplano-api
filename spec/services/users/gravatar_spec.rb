require 'rails_helper'

describe Users::Gravatar do
  describe '.call' do
    subject { described_class.call(params) }

    let(:url) { 'http://example.com/avatar?hash=%{hash}&size=%{size}&email=%{email}&username=%{username}' }
    let(:params) do
      {
        email: 'wat@so.yeah',
        size: 100,
        scale: 2,
        username: 'user'
      }
    end

    before do
      allow_any_instance_of(described_class).to receive(:gravatar_config).and_return('plain_url' => url)
    end

    it 'replaces the placeholders' do
      avatar_url = subject

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
