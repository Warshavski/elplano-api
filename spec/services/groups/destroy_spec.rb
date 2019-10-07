# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Groups::Destroy do
  describe '.call' do
    subject { described_class.call(group, actor) }

    let_it_be(:student) { create(:student, :group_supervisor) }

    let_it_be(:group) { student.group }
    let_it_be(:actor) { student.user }

    it { expect { subject }.to change(Group, :count).by(-1) }

    it { is_expected.to eq(group) }
  end
end
