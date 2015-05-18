require_relative 'shared/base_resource_list'
require_relative 'xml'

module Resync
  class ResourceList < BaseResourceList
    include ::XML::Mapping
    include XML::Convertible

    CAPABILITY = 'resourcelist'
  end
end
