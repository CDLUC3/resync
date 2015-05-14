require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  class ResourceList < BaseResourceList
    include XML::Convertible
    XML_TYPE = XML::Urlset
    CAPABILITY = 'resourcelist'
  end
end
