require_relative 'base_resource_list'

module Resync
  # An extension to +BaseResourceList+ for resource lists that
  # should be sorted by modification time.
  class SortedResourceList < BaseResourceList

    # ------------------------------------------------------------
    # Custom setters

    # Sets the +resources+ list, sorting the resources by modification
    # time. (+nil+ is treated as an empty list.) Resources without
    # modification times will be sorted to the end.
    def resources=(value)
      super(sorted(value))
      @resources_by_uri = by_uri(resources)
    end

    # ------------------------------------------------------------
    # Custom accessors

    # @return [Hash<URI, Array<Resource>>] resources grouped by URI.
    #   Order is not guaranteed.
    attr_reader :resources_by_uri

    # @param uri [URI] the URI of the resource
    # @return [Resource] the resource with the most recent modified time
    #   for the specified URI.
    def latest_for(uri:)
      uri = XML.to_uri(uri)
      @resources_by_uri[uri].last
    end

    # @return [Array<URI>] the set of all URIs for which this list has
    #   resources. Order is not guaranteed.
    def all_uris
      @resources_by_uri.keys
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Conversions

    def sorted(value)
      return [] unless value
      value.sort do |left, right|
        if left.modified_time && right.modified_time
          left.modified_time <=> right.modified_time
        elsif right.modified_time
          1
        elsif left.from_time && right.from_time
          left.from_time <=> right.from_time
        else
          right.from_time ? 1 : -1
        end
      end
    end

    def by_uri(resources)
      by_uri = {}
      resources.each do |r|
        (by_uri[r.uri] ||= []) << r
      end
      by_uri
    end
  end
end
