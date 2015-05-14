require 'xml/mapping'

module Resync
  module XML
    class Urlset
      include ::XML::Mapping

      array_node :url, 'url', class: Url, default_value: []

      object_node :metadata, 'md', class: Md, default_value: nil
      array_node :links, 'ln', class: Ln, default_value: []
    end
  end
end
