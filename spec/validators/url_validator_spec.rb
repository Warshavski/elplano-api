# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlValidator, type: :model do
  subject { dummy.new }

  context 'when allow nil option not set' do
    let_it_be(:dummy) do
      Class.new do
        include ActiveModel::Validations

        attr_accessor :url

        validates :url, url: true
      end
    end

    it { is_expected.to allow_value('http://valid.com').for(:url) }

    it { is_expected.to allow_value('https://valid.com').for(:url) }

    it { is_expected.not_to allow_value('').for(:url) }

    it { is_expected.not_to allow_value(nil).for(:url) }

    it { is_expected.not_to allow_value('123456').for(:url) }

    it { is_expected.not_to allow_value('wat.com').for(:url) }
  end

  context 'when allow nil is set to true' do
    let_it_be(:dummy) do
      Class.new do
        include ActiveModel::Validations

        attr_accessor :url

        validates :url, url: true, allow_nil: true
      end
    end

    it { is_expected.to allow_value(nil).for(:url) }
  end

  context 'when allow nil is set to false' do
    let_it_be(:dummy) do
      Class.new do
        include ActiveModel::Validations

        attr_accessor :url

        validates :url, url: true, allow_nil: false
      end
    end

    it { is_expected.not_to allow_value(nil).for(:url) }
  end
end
