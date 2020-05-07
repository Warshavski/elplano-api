# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Settings::Manage do
  let_it_be(:admin) { create(:user, :admin) }

  describe '#execute' do
    let(:instance) { described_class.new }

    subject { instance.execute(admin, settings_params) }

    context 'when settings params are valid' do
      let(:settings_params) { build(:admin_setting_params) }

      it 'is expected to update settings' do
        log_message =
          "Setting was updated with params: \"#{settings_params}\" " \
          "by \"#{admin.username}\" (#{admin.email})"

        expect(instance).to receive(:log_info).with(log_message)

        expect { subject }.to change(ApplicationSetting, :count).by(7)
      end
    end

    context 'when settings params are not valid' do
      let(:settings_params) { { app_contact_username: ' ' } }

      it 'is expected to not update settings' do
        expect(instance).not_to receive(:log_info)

        expect { subject }.to(
          raise_error(ActiveRecord::RecordInvalid)
            .and(not_change(ApplicationSetting, :count))
        )
      end
    end
  end
end
