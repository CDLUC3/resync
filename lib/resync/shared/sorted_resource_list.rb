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
      @resources = sorted(value)
      @resources_by_uri = by_uri(@resources)
    end

    # ------------------------------------------------------------
    # Custom accessors

    attr_reader :resources_by_uri

    def latest_for(uri:)
      uri = XML.to_uri(uri)
      @resources_by_uri[uri].last
    end

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
        else
          right.modified_time ? 1 : -1
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
