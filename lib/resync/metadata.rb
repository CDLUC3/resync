module Resync
  class Metadata

    # ------------------------------------------------------------
    # Attributes

    attr_reader :at_time
    attr_reader :from_time
    attr_reader :until_time
    attr_reader :completed_time
    attr_reader :modified_time

    attr_reader :length

    # ------------------------------------------------------------
    # Initializer

    def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        at_time: nil,
        from_time: nil,
        until_time: nil,
        completed_time: nil,
        modified_time: nil,
        length: nil
    )
      @at_time = time_or_nil(at_time)
      @from_time = time_or_nil(from_time)
      @until_time = time_or_nil(until_time)
      @completed_time = time_or_nil(completed_time)
      @modified_time = time_or_nil(modified_time)

      @length = natural_number_or_nil(length)
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Parameter validators

    def time_or_nil(time)
      fail ArgumentError, "time #{time} is not a Time" if time && !time.is_a?(Time)
      time
    end

    def natural_number_or_nil(value)
      fail ArgumentError, "value #{value} must be a non-negative integer" if value && (!value.is_a?(Integer) || value < 0)
      value
    end

  end
end
