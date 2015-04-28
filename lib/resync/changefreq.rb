require 'ruby-enum'

module Resync
  class Changefreq
    include Ruby::Enum

    define :always, 'always'
    define :hourly, 'hourly'
    define :daily, 'daily'
    define :weekly, 'weekly'
    define :monthly, 'monthly'
    define :yearly, 'yearly'
    define :never, 'never'
  end
end
