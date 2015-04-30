require 'xml/mapping'

module Resync
  class Sitemapindex
    include XML::Mapping

    # tag 'sitemapindex'

    # has_many :any, Any
    array_node :sitemap, 'sitemap', class: Sitemap, :default_value => []
  end
end
