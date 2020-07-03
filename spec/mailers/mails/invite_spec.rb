# frozen_string_literal: true

require "rails_helper"

RSpec.describe Emails::Invite, type: :mailer do
  before do
    # El Plano <example@example.com>
    address = Mail::Address.new('wat@example.com')
    address.display_name = 'wat'

    allow_any_instance_of(Notify).to receive(:default_sender_address).and_return(address)

    stub_env('UI_HOST', ui_host)
  end

  let(:ui_host) { 'http://elplano.app' }

  describe "#invitation" do
    let(:invite) { create(:invite, :rnd_group) }

    subject { Notify.invitation(invite.id) }

    it 'is expected to compose letter content' do
      expect(subject.subject).to eq('Invite was created for you')

      expect(subject.to).to eq(["#{invite.email}"])

      expect(subject.from).to eq(["wat@example.com"])

      expect(subject.body.encoded).to match("You were invited to the group: #{invite.group.title}")
      expect(subject.body.encoded).to match("By: #{invite.sender.email}")
      expect(subject.body.encoded).to include("<p><a href=\"#{ui_host}/accept-invite?invitation_token=#{invite.invitation_token}\">Accept invite</a></p>")
    end
  end
end
