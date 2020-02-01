# frozen_string_literal: true

require 'rails_helper'

describe ColorMatchable do
  describe '#generate_text_color' do
    let_it_be(:model) { Class.new { include ColorMatchable } }

    subject { model.new }

    it 'generates light text for dark backgrounds' do
      expect(subject.generate_text_color('#222E2E')).to eq('#FFFFFF')
    end

    it 'generates dark text for light backgrounds' do
      expect(subject.generate_text_color('#EEEEEE')).to eq('#333333')
    end

    it 'supports RGB triplets' do
      expect(subject.generate_text_color('#FFF')).to eq '#333333'
      expect(subject.generate_text_color('#000')).to eq '#FFFFFF'
    end
  end
end
