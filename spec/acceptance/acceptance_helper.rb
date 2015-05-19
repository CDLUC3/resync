# ------------------------------------------------------------
# Rspec configuration

require 'rspec'

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.mock_with :rspec
end

require 'rspec_custom_matchers'

# ------------------------------------------------------------
# Stash::Harvester

require 'resync'
