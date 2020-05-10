# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::Update do
  describe '.call' do
    subject { described_class.call(event, params) }

    let(:event) { create(:event) }

    context 'when params are valid' do
      let_it_be(:params) { build(:event_params) }

      it 'is expected to update an event' do
        is_expected.to be_an(Event)

        event.reload

        params.without(:eventable_type).each do |key, value|
          expect(event[key]).to eq(value)
        end

        expect(event.eventable_type).to eq(params[:eventable_type].titleize)
      end

      it 'is expected to create activity event' do
        expect { subject }.to change(ActivityEvent, :count).by(1)
      end
    end

    context 'when params are not valid' do
      let_it_be(:params) { build(:invalid_event_params) }

      it 'is expected to not create event and activity event' do
        expect { subject }.to(
          raise_error(ActiveRecord::RecordInvalid)
            .and(not_change { event })
            .and(not_change(ActivityEvent, :count))
        )
      end
    end
  end
end
