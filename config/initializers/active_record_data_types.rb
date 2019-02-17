module ActiveRecord
  module ConnectionAdapters
    if const_defined?(:PostgreSQLAdapter)
      class PostgreSQLAdapter
        NATIVE_DATABASE_TYPES.merge!(
          event_status:  { name: 'character varying' }
        )
      end
    end
  end
end
