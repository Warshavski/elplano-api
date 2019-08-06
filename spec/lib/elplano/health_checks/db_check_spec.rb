require 'rails_helper'

describe Elplano::HealthChecks::DbCheck do
  include_examples 'simple_check', 'db_ping', 'Db', '1'
end
