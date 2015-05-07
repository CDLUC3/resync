require_relative 'list_base'

module Resync
  class ChangeDump < ListBase

    CAPABILITY = 'changedump'

    def initialize(resources: nil, metadata: nil)
      super(resources: sorted(resources), metadata: metadata)
    end

    # ------------------------------------------------------------
    # Private methods

    private

    # ------------------------------
    # Conversions

    def sorted(resources)
      return nil unless resources
      resources.sort do |left, right|
        if left.lastmod && right.lastmod
          left.lastmod <=> right.lastmod
        else
          right.lastmod ? 1 : -1
        end
      end
    end

  end
end
