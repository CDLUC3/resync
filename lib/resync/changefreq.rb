require 'ruby-enum'

module Resync
  class Changefreq
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
