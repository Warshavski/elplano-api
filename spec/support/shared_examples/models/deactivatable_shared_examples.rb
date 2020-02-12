# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'deactivatable' do
  let_it_be(:model)  { described_class }

  context 'scopes' do
    let_it_be(:active)    { create(model.to_s.underscore.to_sym, active: true) }
    let_it_be(:inactive)  { create(model.to_s.underscore.to_sym, active: false) }

    describe '.active' do
      subject { described_class.active }

      it { is_expected.to eq([active]) }
    end

    describe '.deactivated' do
      subject { described_class.deactivated}

      it { is_expected.to eq([inactive]) }
    end
  end

  describe '#deactivate!' do
    let_it_be(:entity) { create(model.to_s.underscore.to_sym, active: true) }

    subject { entity.deactivate! }

    it { expect { subject }.to change(entity, :active).to(false) }
  end

  describe '#activate' do
    let_it_be(:entity) { create(model.to_s.underscore.to_sym, active: false) }

    subject { entity.activate! }

    it { expect { subject }.to change(entity, :active).to(true) }
  end
end
