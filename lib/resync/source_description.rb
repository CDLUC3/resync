require_relative 'shared/base_resource_list'

module Resync
  class SourceDescription < BaseResourceList
    include ::XML::Mapping
    include XML::Convertible

    CAPABILITY = 'description'
  end
end
