require 'xml/mapping'

module Resync
  class Sitemapindex
    include XML::Mapping

    array_node :sitemap, 'sitemap', class: Sitemap, :default_value => []

    object_node :md, 'md', :class => Md, :default_value => nil
  end
end
