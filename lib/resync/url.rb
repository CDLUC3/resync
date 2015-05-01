require 'xml/mapping'
require 'bigdecimal'
require 'uri'

module Resync
  class Url
    include XML::Mapping

    # tag 'url'

    uri_node :loc, 'loc', :default_value => nil
    time_node :lastmod, 'lastmod', :default_value => nil
    changefreq_node :changefreq, 'changefreq', :default_value => nil
    numeric_node :priority, 'priority', :default_value => nil

    object_node :md, 'md', :class => Md, :default_value => nil
    array_node :ln, 'ln', class: Ln, :default_value => []
  end
end
