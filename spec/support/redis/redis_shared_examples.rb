# frozen_string_literal: true

RSpec.shared_examples 'redis_shared_examples' do
  after { clear_raw_config }

  describe '.params' do
    subject { described_class.params }

    it 'withstands mutation' do
      params1 = described_class.params
      params2 = described_class.params

      params1[:foo] = :bar

      expect(params2).not_to have_key(:foo)
    end
  end

  def clear_raw_config
    described_class.remove_instance_variable(:@_raw_config)
  rescue NameError
    # raised if @_raw_config was not set; just ignore
  end
end
