# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Paginatable do
  before do
    class FakeFinder
      include Paginatable

      attr_reader :params

      def execute(scope, params)
        @params = params

        paginate(scope)
      end
    end
  end

  after { Object.send :remove_const, :FakeFinder }

  subject { FakeFinder.new.execute(User, params) }

  context 'when last id and direction are set' do
    let_it_be(:users) { create_list(:user, 3) }

    let(:params) do
      {
        limit: nil,
        field: nil,
        direction: 'asc',
        field_value: nil,
        last_id: users.first.id - 1
      }
    end

    it { is_expected.to eq(users) }
  end

  context 'when field and direction are set' do
    let_it_be(:last_user)    { create :user, username: 'c' }
    let_it_be(:first_user)   { create :user, username: 'a' }
    let_it_be(:middle_user)  { create :user, username: 'b' }

    context 'when direction is ascending' do
      let(:params) do
        {
          limit: 3,
          field: 'username',
          direction: 'asc',
          field_value: nil,
          last_id: nil
        }
      end

      it { is_expected.to eq([first_user, middle_user, last_user]) }
    end

    context 'when direction is descending' do
      let(:params) do
        {
          limit: 3,
          field: 'username',
          direction: 'desc',
          field_value: nil,
          last_id: nil
        }
      end

      it { is_expected.to eq([last_user, middle_user, first_user]) }
    end
  end

  context 'when last value is defined' do
    let_it_be(:unexpected_user)       { create :user, created_at: 2.days.ago }
    let_it_be(:first_expected_user)   { create :user, created_at: 1.day.ago }
    let_it_be(:second_expected_user)  { create :user, created_at: Time.current }

    let(:params) do
      {
        limit: 2,
        field: 'created_at',
        direction: 'asc',
        field_value: unexpected_user.created_at.to_s,
        last_id: unexpected_user.id
      }
    end

    it { is_expected.to eq [first_expected_user, second_expected_user] }
  end
end
