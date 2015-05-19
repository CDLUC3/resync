require_relative 'shared/descriptor'
require_relative 'xml'

module Resync

  class Metadata < Descriptor
    include XML::Mapped

    # ------------------------------------------------------------
    # Attributes

    root_element_name 'md'

    time_node :at_time, '@at', default_value: nil
    time_node :from_time, '@from', default_value: nil
    time_node :until_time, '@until', default_value: nil
    time_node :completed_time, '@completed', default_value: nil
    change_node :change, '@change', default_value: nil
    text_node :capability, '@capability', default_value: nil

    # ------------------------------------------------------------
    # Initializer

    def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        at_time: nil,
        from_time: nil,
        until_time: nil,
        completed_time: nil,
        modified_time: nil,

        length: nil,
        mime_type: nil,
        encoding: nil,
        hashes: nil,

        change: nil,
        capability: nil,
        path: nil
    )
      super(modified_time: modified_time, length: length, mime_type: mime_type, encoding: encoding, hashes: hashes, path: path)

      self.at_time = at_time
      self.from_time = from_time
      self.until_time = until_time
      self.completed_time = completed_time

      self.change = change
      self.capability = capability
    end

    # ------------------------------------------------------------
    # Custom setters

    def at_time=(value)
      @at_time = time_or_nil(value)
    end

    def from_time=(value)
      @from_time = time_or_nil(value)
    end

    def until_time=(value)
      @until_time = time_or_nil(value)
    end

    def completed_time=(value)
      @completed_time = time_or_nil(value)
    end
  end
end
