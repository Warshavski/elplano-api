# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Searchable do
  let_it_be(:dummy) { Class.new { include Searchable } }

  describe '.to_pattern' do
    subject { dummy.to_pattern(query) }

    context 'when a query is a shorter than 3 chars' do
      context 'exact matching pattern' do
        let(:query) { 'wa' }

        it { is_expected.to eq(query) }
      end

      context 'sanitized exact matching pattern' do
        let(:query) { 'w_' }

        it { is_expected.to eq('w\_') }
      end
    end

    context 'when a query is equal to 3 chars' do
      context 'partial matching pattern' do
        let(:query) { 'wat' }

        it { is_expected.to eq('%wat%') }
      end

      context 'sanitized partial matching pattern' do
        let(:query) { 'wa_' }

        it { is_expected.to eq('%wa\_%') }
      end
    end

    context 'when a query is longer than 3 chars' do
      context 'partial matching pattern' do
        let(:query) { 'query' }

        it { is_expected.to eq('%query%') }
      end

      context 'sanitized partial matching pattern' do
        let(:query) { 'que_ry' }

        it { is_expected.to eq('%que\_ry%') }
      end
    end
  end

  describe '.select_fuzzy_words' do
    subject { User.select_fuzzy_words(query) }

    context 'with a word equal to 3 chars' do
      let(:query) { 'wat' }

      it { is_expected.to match_array([query]) }
    end

    context 'with a word shorter than 3 chars' do
      let(:query) { 'wa' }

      it { is_expected.to match_array([]) }
    end

    context 'with two words both equal to 3 chars' do
      let(:query) { 'wat hey' }

      it { is_expected.to match_array(%w[wat hey]) }
    end

    context 'with two words divided by two spaces both equal to 3 chars' do
      let(:query) { 'wat  hey' }

      it { is_expected.to match_array(%w[wat hey]) }
    end

    context 'with two words equal to 3 chars and shorter than 3 chars' do
      let(:query) { 'wat so' }

      it { is_expected.to match_array(['wat']) }
    end

    context 'with a multi-word surrounded by double quote' do
      let(:query) { '"fantastic wat"' }

      it { is_expected.to match_array(['fantastic wat']) }
    end

    context 'with multi-word surrounded by double quote and two words' do
      let(:query) { 'wat "fantastic" hey' }

      it { is_expected.to match_array(%w[wat hey fantastic]) }
    end

    context 'with multi-word surrounded by double quote missing a space before the first double quote' do
      let(:query) { 'wat"fantastic hey"' }

      it { is_expected.to match_array(%w[wat"fantastic hey"]) }
    end

    context 'with a multi-word surrounded by double quote missing a space after the second double qoute' do
      let(:query) { '"fantastic wat"hey' }

      it { is_expected.to match_array(%w["fantastic wat"hey]) }
    end

    context 'with two multi-word surrounded by double quote and two words' do
      let(:query) { 'wat "fantastic app" hey "awesome feature"' }

      it { is_expected.to match_array(['wat', 'fantastic app', 'hey', 'awesome feature']) }
    end
  end

  describe '.fuzzy_arel_match' do
    subject { User.fuzzy_arel_match(:username, query) }

    context 'with a word equal to 3 chars' do
      let(:query) { 'wat' }

      it 'returns a single ILIKE condition' do
        expect(subject.to_sql).to match(/username.*I?LIKE '\%wat\%'/)
      end
    end

    context 'with a word shorter than 3 chars' do
      let(:query) { 'so' }

      it 'returns a single equality condition' do
        expect(subject.to_sql).to match(/username.*I?LIKE 'so'/)
      end

      it 'uses LOWER instead of ILIKE when LOWER is enabled' do
        rel = User.fuzzy_arel_match(:username, query, lower_exact_match: true)

        expect(rel.to_sql).to match(/LOWER\(.*username.*\).*=.*'so/)
      end
    end

    context 'with two words both equal to 3 chars' do
      let(:query) { 'wat hey' }

      it 'returns a joining LIKE condition using AND' do
        expect(subject.to_sql).to match(/username.+I?LIKE '\%wat\%' AND .*username.*I?LIKE '\%hey\%/)
      end
    end

    context 'with two words both  shorter than 3 chars' do
      let(:query) { 'so wa' }

      it 'returns a single ILIKE condition' do
        expect(subject.to_sql).to match(/username.*I?LIKE 'so wa'/)
      end
    end

    context 'with two words, one shorter 3 chars' do
      let(:query) { 'wat so' }

      it 'returns a single ILIKE condition using the longer word' do
        expect(subject.to_sql).to match(/username.+I?LIKE '\%wat\%'/)
      end
    end

    context 'with a multi-word surrounded by double quote and two words' do
      let(:query) { 'wat "fantastic app" hey' }

      it 'returns a joining LIKE condition using AND' do
        expect(subject.to_sql).to match(/username.+I?LIKE '\%wat\%' AND .*username.*I?LIKE '\%hey\%' AND .*username.*I?LIKE '\%fantastic app\%'/)
      end
    end
  end
end
