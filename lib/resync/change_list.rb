require_relative 'base_sorted_list'

module Resync
  class ChangeList < BaseSortedList
    CAPABILITY = 'changelist'
  end
end
