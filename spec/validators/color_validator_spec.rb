# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ColorValidator, type: :model do
  subject { dummy.new }

  context 'when allow nil option not set' do
    let_it_be(:dummy) do
      Class.new do
        include ActiveModel::Validations

        attr_accessor :color

        validates :color, color: true
      end
    end

    it { is_expected.to allow_value('#1f1f1F').for(:color) }

    it { is_expected.to allow_value('#AFAFAF').for(:color) }

    it { is_expected.to allow_value('#222fff').for(:color) }

    it { is_expected.to allow_value('#F00').for(:color) }

    it { is_expected.to allow_value('#1AFFa1').for(:color) }

    it { is_expected.to allow_value('#000000').for(:color) }

    it { is_expected.to allow_value('#ea00FF').for(:color) }

    it { is_expected.to allow_value('#eb0').for(:color) }

    it { is_expected.not_to allow_value('123456').for(:color) }

    it { is_expected.not_to allow_value('#afafah').for(:color) }

    it { is_expected.not_to allow_value('#123abce').for(:color) }

    it { is_expected.not_to allow_value('aFaE3f').for(:color) }

    it { is_expected.not_to allow_value('F00').for(:color) }

    it { is_expected.not_to allow_value('#afaf').for(:color) }

    it { is_expected.not_to allow_value('#afaf').for(:color) }

    it { is_expected.not_to allow_value('#F0h').for(:color) }

    it { is_expected.not_to allow_value('').for(:color) }

    it { is_expected.not_to allow_value(0).for(:color) }

    it { is_expected.not_to allow_value('#1f1f1F1f1f1F').for(:color) }
  end

  context 'when allow nil is set to true' do
    let_it_be(:dummy) do
      Class.new do
        include ActiveModel::Validations

        attr_accessor :color

        validates :color, color: true, allow_nil: true
      end
    end

    it { is_expected.to allow_value(nil).for(:color) }
  end

  context 'when allow nil is set to false' do
    let_it_be(:dummy) do
      Class.new do
        include ActiveModel::Validations

        attr_accessor :color

        validates :color, color: true, allow_nil: false
      end
    end

    it { is_expected.not_to allow_value(nil).for(:color) }
  end
end
