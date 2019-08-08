require 'rails_helper'

RSpec.describe Information::Compose do
  describe '.call' do
    subject { described_class.call }

    before do
      allow_any_instance_of(described_class).to receive(:app_contact_email).and_return('email')
      allow_any_instance_of(described_class).to receive(:app_contact_username).and_return('username')
      allow_any_instance_of(described_class).to receive(:app_title).and_return('title')
      allow_any_instance_of(described_class).to receive(:app_short_description).and_return('short desc')
      allow_any_instance_of(described_class).to receive(:app_description).and_return('desc')
      allow_any_instance_of(described_class).to receive(:app_extended_description).and_return('ext desc')
      allow_any_instance_of(described_class).to receive(:app_terms).and_return('terms')

      allow(Elplano).to receive(:version).and_return('v1')
      allow(Elplano).to receive(:revision).and_return('rev')
    end

    let_it_be(:expected_meta) do
      {
        app_version: 'v1',
        app_revision: 'rev',
        app_contact_email: 'email',
        app_contact_username: 'username',
        app_title: 'title',
        app_short_description: 'short desc',
        app_description: 'desc',
        app_extended_description: 'ext desc',
        app_terms: 'terms'
      }
    end

    it { is_expected.to eq(expected_meta) }
  end
end
