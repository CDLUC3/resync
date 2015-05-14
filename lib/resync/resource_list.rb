require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  class ResourceList < BaseResourceList
    include XML::Convertible
    CAPABILITY = 'resourcelist'
    XML_TYPE = XML::Urlset
  end
end
