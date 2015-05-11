require_relative 'base_sorted_list'

module Resync
  class ChangeDump < BaseSortedList
    CAPABILITY = 'changedump'
  end
end
