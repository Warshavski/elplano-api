# frozen_string_literal: true

module Elplano
  module HealthChecks
    Metric = Struct.new(:name, :value, :labels)
  end
end
