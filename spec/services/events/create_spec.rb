# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::Create do
  describe '.call' do
    subject { described_class.call(author, params) }

    let_it_be(:author) { create(:student) }

    context 'when params are valid' do
      let_it_be(:params) { build(:event_params) }

      it { is_expected.to be_an(Event) }

      it { expect { subject }.to change(Event, :count).by(1) }

      it 'triggers passed block' do
        expect { |b| described_class.call(author, params, &b) }.to yield_control.once
      end
    end

    context 'when params are not valid' do
      let_it_be(:params) { build(:invalid_event_params) }

      it 'does not creates event' do
        expect { subject }.to(
          raise_error(ActiveRecord::RecordInvalid).and not_change(Event, :count)
        )
      end

      it 'does not triggers passed block' do
        expect { |b| described_class.call(author, params, &b) }.to(
          raise_error(ActiveRecord::RecordInvalid).and not_yield_control
        )
      end
    end
  end
end
