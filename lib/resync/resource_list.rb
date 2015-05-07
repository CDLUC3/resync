require_relative 'list_base'

module Resync
  class ResourceList < ListBase

    CAPABILITY = 'resourcelist'

    def initialize(resources: nil, metadata: nil)
      super
    end

  end
end
