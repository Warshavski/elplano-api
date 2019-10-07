# frozen_string_literal: true

require 'rails_helper'

describe Elplano::Loggers::AppLogger, :request_store do
  subject { described_class }

  it 'builds a logger once' do
    expect(::Logger).to receive(:new).and_call_original

    subject.info('hello world')
    subject.error('hello again')
  end
end
