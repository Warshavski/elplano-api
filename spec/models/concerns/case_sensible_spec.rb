require 'rails_helper'

describe CaseSensible do
  describe '.iwhere' do
    let(:connection) { ActiveRecord::Base.connection }

    let(:model) do
      Class.new(ActiveRecord::Base) do
        include CaseSensible

        self.table_name = 'users'
      end
    end

    let!(:first_model)  { model.create(email: 'mOdEl-1', username: 'mOdEl 1') }
    let!(:second_model) { model.create(email: 'mOdEl-2', username: 'mOdEl 2') }

    it 'finds a single instance by a single attribute regardless of case' do
      expect(model.iwhere(email: 'MODEL-1')).to contain_exactly(first_model)
    end

    it 'finds multiple instances by a single attribute regardless of case' do
      expect(model.iwhere(email: %w[MODEL-1 model-2])).to contain_exactly(first_model, second_model)
    end

    it 'finds instances by multiple attributes' do
      expect(model.iwhere(email: %w[MODEL-1 model-2], username: 'model 1')).to contain_exactly(first_model)
    end
  end
end
