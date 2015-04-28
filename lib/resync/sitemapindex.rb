require 'happymapper'

module Resync
  class Sitemapindex
    include HappyMapper

    tag 'sitemapindex'

    # has_many :any, Any
    has_many :sitemap, Sitemap
  end
end
