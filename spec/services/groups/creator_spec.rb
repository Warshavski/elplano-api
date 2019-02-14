require 'rails_helper'

RSpec.describe Groups::Creator do
  subject { described_class.new.execute(owner, params) }

  let(:params) { { number: '123', title: 'wat' } }

  context 'when owner already has a group' do
    let(:owner) { create(:president) }

    it 'throws validation error' do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid, 'student already has a group!')
    end
  end

  context 'when owner has no group' do
    let(:owner) { create(:student) }

    it { expect { subject }.to change(Group, :count).by 1 }

    it { expect(subject).to be_an Group }

    it { expect(subject.number).to eq(params[:number]) }

    it { expect(subject.title).to eq(params[:title]) }

    it 'appoints an owner as group president' do
      expect(subject.president).to eq(owner)
    end

    it 'adds owner as group member' do
      expect(subject.students).to eq([owner])
    end

    context 'invalid title in params' do
      let(:params) { { title: nil } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end

    context 'invalid number in params' do
      let(:params) { { number: nil } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end
end
