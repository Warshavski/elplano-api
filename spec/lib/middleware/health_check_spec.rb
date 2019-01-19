# frozen_string_literal: true

require 'rails_helper'
require 'middleware/health_check'

describe Middleware::HealthCheck do
  let(:app) { double(:app) }
  let(:middleware) { described_class.new(app) }
  let(:env) { {} }

  describe '#call' do
    context 'outside IP' do
      before { env['REMOTE_ADDR'] = '8.8.8.8' }

      it 'returns a 404 status' do
        env['PATH_INFO'] = described_class::HEALTH_PATH

        response = middleware.call(env)

        expect(response[0]).to be(404)
      end

      it 'forwards the call for other paths' do
        env['PATH_INFO'] = '/'

        expect(app).to receive(:call)

        middleware.call(env)
      end
    end

    context 'whitelisted IP' do
      before { env['REMOTE_ADDR'] = '127.0.0.1' }

      it 'returns 200 response when endpoint is hit' do
        env['PATH_INFO'] = described_class::HEALTH_PATH

        expect(app).not_to receive(:call)

        response = middleware.call(env)

        expect(response[0]).to be(200)
        expect(response[1]).to eq('Content-Type' => 'text/plain')
        expect(response[2]).to eq(['Elplano OK'])
      end

      it 'forwards the call for other paths' do
        env['PATH_INFO'] = '/-/readiness'

        expect(app).to receive(:call)

        middleware.call(env)
      end
    end
  end
end
