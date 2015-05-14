require 'xml/mapping'

module Resync
  module XML
    class Url
      include ::XML::Mapping

      uri_node :uri, 'loc', default_value: nil
      time_node :modified_time, 'lastmod', default_value: nil
      changefreq_node :changefreq, 'changefreq', default_value: nil
      numeric_node :priority, 'priority', default_value: nil

      object_node :metadata, 'md', class: Md, default_value: nil
      array_node :links, 'ln', class: Ln, default_value: []
    end
  end
end
