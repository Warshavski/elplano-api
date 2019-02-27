require 'rails_helper'

RSpec.describe Invites::Create do
  # Two in one
  describe '.call' do
    subject { described_class.call(student, params) }

    let_it_be(:student) { create(:student, :group_supervisor) }

    context 'valid arguments' do
      let(:params) do
        {
          email: 'seems@legit.email',
          group: student.supervised_group
        }
      end

      it 'creates invite for specified email' do
        expect(subject.email).to eq(params[:email])
      end

      it 'creates invite with specified sender' do
        expect(subject.sender).to eq(student)
      end

      it "creates invite with sender's group" do
        expect(subject.group).to eq(params[:group])
      end

      context 'invite presence' do
        it { expect { subject }.to change(Invite, :count).by(1) }
      end

      # HA! tricky things down here
      context 'notification presence' do
        it 'triggers notification' do
          service = described_class.new(student)
          expect(service).to receive(:notify_about).once

          service.execute(params)
        end
      end
    end

    context 'invalid arguments' do
      context 'invalid params' do
        let(:params) { { email: nil } }

        it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
      end

      context 'invalid student' do
        let_it_be(:student) { nil }
        let_it_be(:params) do
          {
            email: 'seems@legit.email',
            group: create(:group)
          }
        end

        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end
  end
end
