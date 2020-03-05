# frozen_string_literal: true

RSpec.shared_examples 'valid runtime' do |runtime, max_threads|
  it 'is expected to identify itself' do
    expect(subject.public_send("#{runtime}?")).to be(true)
  end

  it 'is expected to report its maximum concurrency' do
    expect(subject.max_threads).to eq(max_threads)
  end
end
