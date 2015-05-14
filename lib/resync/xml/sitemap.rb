require 'xml/mapping'
require 'uri'

module Resync
  module XML
    class Sitemap
      include ::XML::Mapping

      uri_node :uri, 'loc', default_value: nil
      text_node :modified_time, 'lastmod', default_value: nil

      object_node :metadata, 'md', class: Md, default_value: nil
      array_node :links, 'ln', class: Ln, default_value: []
    end
  end
end
