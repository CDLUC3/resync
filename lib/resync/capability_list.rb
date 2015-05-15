require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  class CapabilityList < BaseResourceList
    include ::XML::Mapping
    include XML::Convertible
    XML_TYPE = XML::Urlset
    CAPABILITY = 'capabilitylist'

    # ------------------------------------------------------------
    # Attributes

    attr_reader :source_description
    xml_placeholder # Workaround for https://github.com/multi-io/xml-mapping/issues/4

    # ------------------------------------------------------------
    # Initializer

    def initialize(resources: nil, links: nil, metadata: nil)
      @source_description = source_description_from(links)
      @capabilities = to_capability_map(resources)
      super(resources: @capabilities.values, links: links, metadata: metadata)
    end

    # ------------------------------------------------------------
    # Public methods

    def resource_for(capability:)
      @capabilities[capability]
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Conversions

    def to_capability_map(resources)
      capabilities = {}
      (resources || []).each do |resource|
        capability = resource.capability
        fail ArgumentError, "No capability found for resource with URI #{resource.uri}" unless capability
        fail ArgumentError, "Duplicate resource for capability #{capability}" if capabilities.key?(capability)
        capabilities[capability] = resource
      end
      capabilities
    end

    def source_description_from(links)
      return nil unless links
      desc = links.map { |link| link.href if link.rel == 'up' }.compact.first
      fail ArgumentError, "No source descrption (<link rel='up'/>) provided" unless desc
      desc
    end
  end
end
