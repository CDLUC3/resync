require_relative 'shared/base_resource_list'

module Resync
  class SourceDescription < BaseResourceList
    include ::XML::Mapping
    include XML::Convertible
    XML_TYPE = XML::Urlset
    CAPABILITY = 'description'

    xml_placeholder # Workaround for https://github.com/multi-io/xml-mapping/issues/4
  end
end
