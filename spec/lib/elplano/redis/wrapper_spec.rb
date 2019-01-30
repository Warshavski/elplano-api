require 'rails_helper'

describe Elplano::Redis::Wrapper do
  include_examples 'redis_shared_examples'

  describe '.config_file_path' do
    it 'returns the absolute path to the configuration file' do
      expect(described_class.config_file_path('foo.yml'))
        .to eq Rails.root.join('config', 'foo.yml').to_s
    end
  end
end
