# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sortable do
  before do
    class FakeFinder
      include Sortable

      specify_sort :wat do |scope, direction|
        scope.order(title: direction, id: direction)
      end

      specify_sort :so, attributes: :description, direction: :asc

      specify_sort :hey, attributes: :description

      attr_reader :params

      def execute(scope, params)
        @params = params

        sort(scope)
      end
    end
  end

  after { Object.send :remove_const, :FakeFinder }

  subject { FakeFinder.new.execute(Label.all, params) }

  let_it_be(:labels) do
    [2, 1, 3].map do |number|
      create(:label, title: "#{number}title", description:"#{number}description")
    end
  end

  context 'when sort params are not provider' do
    let(:params) { {} }

    it 'is expected to sort by id in descending direction' do
      is_expected.to eq(labels)
    end
  end

  context 'when sort parameter is set in ascending mode' do
    let(:params) { { sort: 'title' } }

    it 'is expected to sort by provided parameter in ascending direction' do
      is_expected.to eq([labels.second, labels.first, labels.third])
    end
  end

  context 'when sort parameter set in descending mode' do
    let(:params) { { sort: '-title' } }

    it 'is expected to sort by provided parameter in descending direction' do
      is_expected.to eq([labels.third, labels.first, labels.second])
    end
  end

  context 'when sort parameter set within multiple attributes' do
    let_it_be(:extra_label) { create(:label, title: '1title' ) }

    let(:params) { { sort: '-title,id' } }

    it 'is expected to sort by provided parameters' do
      is_expected.to eq([labels.third, labels.first, labels.second, extra_label])
    end
  end

  context 'when custom sort parameter is set' do
    let_it_be(:extra_label) do
      create(:label, title: '1title', description: '0description' )
    end

    let(:params) { { sort: '-wat' } }

    it 'is expected to sort by provided parameters' do
      is_expected.to eq([labels.third, labels.first, extra_label, labels.second])
    end

    context 'when sort specified via hash without direction' do
      let(:params) { { sort: 'hey' } }

      it 'is expected to sort by provided parameters' do
        is_expected.to eq([extra_label, labels.second, labels.first, labels.third])
      end

      context 'when direction is set' do
        let(:params) { { sort: '-hey' } }

        it 'is expected to sort by provided parameters' do
          is_expected.to eq([labels.third, labels.first, labels.second, extra_label])
        end
      end
    end

    context 'when sort specified via hash with direction' do
      let(:params) { { sort: 'so' } }

      it 'is expected to sort by provided parameters' do
        is_expected.to eq([extra_label, labels.second, labels.first, labels.third])
      end

      context 'when direction is set' do
        let(:params) { { sort: '-so' } }

        it 'is expected to sort by provided parameters' do
          is_expected.to eq([extra_label, labels.second, labels.first, labels.third])
        end
      end
    end
  end
end
