# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Sendgrid::Metrics do
  describe '.call' do
    subject { described_class.call }

    let_it_be(:params) do
      {
        "aggregated_by"=>"day",
        "start_date"=>"2019-09-15",
        "end_date"=>"2019-10-15"
      }
    end

    let_it_be(:response) do
      "[
        {
          \"date\": \"2019-09-15\",
          \"stats\": [
            {
              \"metrics\": {
                \"blocks\": 0,
                \"clicks\": 0
              }
            }
          ]
        }
      ]"
    end

    before do
      allow(ENV).to receive(:[]).with('SENDGRID_METRICS_API_KEY').and_return('api_key')

      allow(Date).to receive(:current).and_return(Date.parse('2019-10-15'))

      allow_any_instance_of(described_class).to(
        receive(:perform_request).with(params).and_return(sendgrid_metrics)
      )
    end

    context 'when status code is equal 200' do
      let(:sendgrid_metrics) do
        double('response', status_code: '200', body: response)
      end

      it { is_expected.to eq([{ "date" => "2019-09-15", "metrics" => { "blocks" => 0, "clicks" => 0} }]) }
    end

    context 'when status code is not equal 200' do
      let(:sendgrid_metrics) do
        double('response', status_code: '404', body: 'Woops! error occurred')
      end

      it { is_expected.to eq([]) }
    end
  end
end

