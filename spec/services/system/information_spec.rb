require 'rails_helper'

RSpec.describe System::Information do
  describe '.call' do
    let(:memory_struct) do
      double('memory_struct', total_bytes: 8_263_520_256, active_bytes: 5_833_744_384)
    end

    let(:mount_point) do
      double(
        'mount_point',
        options: "rw,relatime,errors=remount-ro,data=ordered",
        mount_type: 'ext4',
        mount_point: '/',
        name: '/dev/sda3'
      )
    end

    let(:file_system_stat) do
      double('file_system_stat', bytes_total: 2, bytes_used: 1, path: '/')
    end

    before do
      allow(Vmstat).to receive(:cpu).and_return([1])
      allow(Vmstat).to receive(:memory).and_return(memory_struct)

      allow(Sys::Filesystem).to receive(:mounts).and_return([mount_point])
      allow(Sys::Filesystem).to receive(:stat).with('/').and_return(file_system_stat)
    end

    subject { described_class.call }

    it 'returns composed system usage information' do
      expected_info = {
        cpu_cores: 1,
        memory_usage: {
          active_bytes: 5_833_744_384,
          total_bytes: 8_263_520_256
        },
        disks_usage: [
          {
            total_bytes: 2,
            active_bytes: 1,
            disk_name: '/dev/sda3',
            mount_path: '/'
          }
        ]
      }

      is_expected.to eq(expected_info)
    end

    context 'when expected errors occurs' do
      before do
        allow(Vmstat).to receive(:cpu).and_raise(StandardError)
        allow(Vmstat).to receive(:memory).and_raise(StandardError)

        allow(Sys::Filesystem).to receive(:stat).with('/').and_raise(Sys::Filesystem::Error)
      end

      it 'returns ' do
        expected_info = {
          cpu_cores: nil,
          memory_usage: nil,
          disks_usage: []
        }

        is_expected.to eq(expected_info)
      end
    end
  end
end
