require_relative 'shared/resource_descriptor'
require_relative 'xml'

module Resync

  class Metadata < ResourceDescriptor
    include XML::Convertible

    XML_TYPE = XML::Md

    # ------------------------------------------------------------
    # Attributes

    attr_reader :at_time
    attr_reader :from_time
    attr_reader :until_time
    attr_reader :completed_time
    attr_reader :change
    attr_reader :capability

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

      @at_time = time_or_nil(at_time)
      @from_time = time_or_nil(from_time)
      @until_time = time_or_nil(until_time)
      @completed_time = time_or_nil(completed_time)

      @change = change
      @capability = capability
    end

  end
end
