require 'happymapper'

module Resync
  class Sitemap
    include HappyMapper

    tag 'sitemap'

    element :loc, String
    element :lastmod, String
    # has_many :any, Any
  end
end
