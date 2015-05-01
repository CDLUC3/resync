require 'xml/mapping'
require 'uri'

module Resync
  class Sitemap
    include XML::Mapping

    uri_node :loc, 'loc', default_value: nil
    text_node :lastmod, 'lastmod', default_value: nil

  end
end
