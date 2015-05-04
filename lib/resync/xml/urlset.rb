require 'xml/mapping'

module Resync
  module XML
    class Urlset
      include ::XML::Mapping

      array_node :url, 'url', class: Url, default_value: []

      object_node :md, 'md', class: Md, default_value: nil
      array_node :ln, 'ln', class: Ln, default_value: []
    end
  end
end
