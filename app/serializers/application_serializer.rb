# frozen_string_literal: true

# ApplicationSerializer
#
#   Used as base class for all serializers
#
class ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  def to_json
    Oj.dump(serializable_hash)
  end
end
