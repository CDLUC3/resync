require_relative 'shared/base_resource_list'

module Resync
  class SourceDescription < BaseResourceList
    include XML::Mapped

    CAPABILITY = 'description'
  end
end
