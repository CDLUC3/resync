require 'delegate'

module Resync
  module Util
    class IndexableLazy < SimpleDelegator

      def initialize(array)
        super(array.lazy)
        @array = array
      end

      def [](key)
        @array[key]
      end

    end
  end
end
