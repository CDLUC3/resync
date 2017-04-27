require 'typesafe_enum'

module Resync
  module Types
    # The frequency of changes to a resource.
    # Values: +ALWAYS+, +HOURLY+, +DAILY+, +WEEKLY+, +MONTHLY+, +YEARLY+, +NEVER+
    class ChangeFrequency < TypesafeEnum::Base
      %i[ALWAYS HOURLY DAILY WEEKLY MONTHLY YEARLY NEVER].each { |cf| new cf }
    end
  end
end
