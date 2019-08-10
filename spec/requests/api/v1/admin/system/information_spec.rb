require 'rails_helper'

RSpec.describe Api::V1::Admin::System::InformationController, type: :request do
  include_context 'shared setup', :admin

  let_it_be(:endpoint) { '/api/v1/admin/system/information' }

  let_it_be(:meta) do
    {
      cpu_cores: 1,
      memory_usage: {
        active_bytes: 5_833_744_384,
        total_bytes: 8_263_520_256
      },
      disks_usage: [
        {
          total_bytes: 229_150_093_312,
          active_bytes: 111_339_143_168,
          disk_name: '/dev/sda3',
          mount_path: '/'
        }
      ]
    }
  end

  before do
    allow(::System::Information).to receive(:call).and_return(meta)
  end

  before(:each) { subject }

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    it { expect(response).to have_http_status(:ok) }

    it { expect(body_as_json[:meta]).to eq(meta.deep_stringify_keys) }
  end
end
