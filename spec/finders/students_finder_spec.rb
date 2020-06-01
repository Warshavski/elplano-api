# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentsFinder do
  describe '#execute' do
    subject { described_class.new(context: group, params: { filter: params }).execute }

    let_it_be(:phone_student)      { create(:student, phone: '9900348621') }
    let_it_be(:email_student)      { create(:student, email: 'wat@email.so') }
    let_it_be(:full_name_student)  { create(:student, phone: 'ffffullname') }

    let_it_be(:group) do
      create(:group, students: [phone_student, email_student, full_name_student])
    end

    context 'when params are default(empty)' do
      let_it_be(:params) { {} }

      it { is_expected.to eq([full_name_student, email_student, phone_student]) }
    end

    context 'when search param is presented' do
      let(:params) { { search: term } }

      context 'when term is a phone part' do
        let(:term) { '990034' }

        it { is_expected.to eq([phone_student]) }
      end

      context 'when term is an email part' do
        let(:term) { 'wat@em' }

        it { is_expected.to eq([email_student]) }
      end

      context 'when term is a phone part' do
        let(:term) { 'ffffu' }

        it { is_expected.to eq([full_name_student]) }
      end
    end
  end
end
