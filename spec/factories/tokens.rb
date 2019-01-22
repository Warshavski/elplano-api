require 'doorkeeper/orm/active_record/application'

FactoryBot.define do
  factory :token, class: Doorkeeper::AccessToken do
    resource_owner_id { create(:user).id }
    expires_in        { 7200 }
  end
end
