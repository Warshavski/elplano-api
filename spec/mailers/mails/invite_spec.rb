require "rails_helper"

RSpec.describe Emails::Invite, type: :mailer do
  before do
    # El Plano <example@example.com>
    address = Mail::Address.new('wat@example.com')
    address.display_name = 'wat'

    allow_any_instance_of(Notify).to receive(:default_sender_address).and_return(address)
  end

  describe "#new_invite" do
    let(:invite) { create(:invite, :rnd_group) }

    subject { Notify.new_invite(invite.id) }

    it { expect(subject.subject).to eq('Invite was created for you') }

    it { expect(subject.to).to eq(["#{invite.email}"]) }

    it { expect(subject.from).to eq(["wat@example.com"]) }

    it { expect(subject.body.encoded).to match("You were invited to the group: #{invite.group.title}") }

    it { expect(subject.body.encoded).to match("By: #{invite.sender.email}") }
  end
end
