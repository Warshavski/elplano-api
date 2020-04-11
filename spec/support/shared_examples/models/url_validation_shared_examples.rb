# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'url validation' do
  it 'is expected to pass validation for well-formed urls' do
    valid_url_values = %w[
        http://www.host.com/courses/71-analytical-figure-drawing
        https://www.anotherhost.com/resource/71-analytical-figure-drawing
      ]

    valid_url_values.each do |url|
      subject.url = url

      expect(subject).to be_valid
    end
  end

  it 'is expected to fall validation for url without scheme' do
    invalid_url_values = [
      nil,
      '',
      'random_string.com'
    ]

    invalid_url_values.each do |url|
      subject.url = url

      expect(subject).not_to be_valid
    end
  end
end
