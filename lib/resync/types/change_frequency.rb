require 'ruby-enum'

module Resync
  module Types
    # The frequency of changes to a resource.
    class ChangeFrequency
      include Ruby::Enum

      define :ALWAYS, 'always'
      define :HOURLY, 'hourly'
      define :DAILY, 'daily'
      define :WEEKLY, 'weekly'
      define :MONTHLY, 'monthly'
      define :YEARLY, 'yearly'
      define :NEVER, 'never'
    end
  end
end
