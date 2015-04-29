require 'happymapper'
require 'uri'

module Resync
  class Sitemap
    include HappyMapper

    tag 'sitemap'

    element :loc, URI
    element :lastmod, String
    # has_many :any, Any
  end
end
