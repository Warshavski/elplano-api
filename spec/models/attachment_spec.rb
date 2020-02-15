# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  context 'associations' do
    it do
      should belong_to(:author)
               .class_name('User')
               .inverse_of(:uploads)
               .with_foreign_key(:user_id)
    end

    it { should belong_to(:attachable) }
  end
end
