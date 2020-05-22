# frozen_string_literal: true

module System
  # System::Information
  #
  #   Used to fetch and compose system usage metadata
  #
  class Information
    EXCLUDED_MOUNT_OPTIONS = %w[nobrowse read-only ro].freeze

    EXCLUDED_MOUNT_TYPES = %w[
      autofs
      binfmt_misc
      cgroup
      debugfs
      devfs
      devpts
      devtmpfs
      efivarfs
      fuse.gvfsd-fuse
      fuseblk
      fusectl
      hugetlbfs
      mqueue
      proc
      pstore
      rpc_pipefs
      securityfs
      sysfs
      tmpfs
      tracefs
      vfat
    ].freeze

    # (see #execute)
    #
    def self.call
      new.execute
    end

    def initialize(system_stats: Vmstat, file_system: Sys::Filesystem)
      @system_stats = system_stats
      @file_system = file_system
    end

    def execute
      compose_metadata(
        fetch_memory_info,
        fetch_cpu_info,
        fetch_disks_info
      )
    end

    private

    def fetch_cpu_info
      @system_stats.cpu
    rescue StandardError
      nil
    end

    def fetch_memory_info
      @system_stats.memory
    rescue StandardError
      nil
    end

    def fetch_disks_info
      @file_system.mounts.each_with_object([]) do |mount, disks|
        mount_options = mount.options.split(',')

        next if (EXCLUDED_MOUNT_OPTIONS & mount_options).any?
        next if (EXCLUDED_MOUNT_TYPES & [mount.mount_type]).any?

        compose_disk_info(mount).tap { |disk_info| disks.push(disk_info) if disk_info }
      end
    end

    def compose_disk_info(mount)
      disk = @file_system.stat(mount.mount_point)
      {
        total_bytes: disk.bytes_total,
        active_bytes: disk.bytes_used,
        disk_name: mount.name,
        mount_path: disk.path
      }
    rescue Sys::Filesystem::Error
      nil
    end

    def compose_metadata(memory, cpu_cores, disks_usage)
      memory_usage =
        memory.nil? ? nil : { active_bytes: memory.active_bytes, total_bytes: memory.total_bytes }

      cpu_cores_count =
        cpu_cores.nil? ? nil : cpu_cores.length

      { cpu_cores: cpu_cores_count, memory_usage: memory_usage, disks_usage: disks_usage }
    end
  end
end
