
module Resync
  class Metadata

    # ------------------------------------------------------------
    # Attributes

    attr_reader :at_time
    attr_reader :from_time
    attr_reader :until_time

    # ------------------------------------------------------------
    # Initializer

    def initialize(at_time: nil, from_time: nil, until_time: nil)
      @at_time = time_or_nil(at_time)
      @from_time = time_or_nil(from_time)
      @until_time = time_or_nil(until_time)
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Parameter validators

    def time_or_nil(time)
      if time && !time.is_a?(Time)
        fail ArgumentError, "time #{time} is not a Time"
      end
      time
    end

  end
end
