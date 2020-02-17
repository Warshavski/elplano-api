# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin system information' do
  explanation <<~DESC
    El Plano administration: System information
    
    Meta payload :

     - `cpu_cores` - Represents quantity of the CPU cores on the server machine.
     - `memory_usage` - Represents RAM memory usage.
      - `active_bytes` - Quantity of the used bytes.
      - `total_bytes` - Quantity of the total bytes on the server machine.
     - `disks_usage` - Represents disks usage.
       - `total_bytes` - Quantity of the total available disk space on the server machine.
       - `active_bytes` - Quantity of the used disk space on the server machine.
       - `disk_name` - Name of the mounted disk.
       - `mount_path` - Path of the mounted disk.
  DESC

  let(:user)  { create(:admin) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/admin/system/information' do
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
      allow(System::Information).to receive(:call).and_return(meta)
    end

    example 'SHOW : Retrieve system information' do
      explanation <<~DESC
        Returns meta-information about used system resources.

        <b>NOTE</b> : 

          - Returns `null` or `[]` in case if information can not be received.
      DESC

      do_request

      expected_meta = { meta: meta }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
