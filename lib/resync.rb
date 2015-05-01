require 'xml/mapping'
require 'time'

module Resync

  class TimeNode < XML::Mapping::SingleAttributeNode
    def initialize(*args)
      path, *args = super(*args)
      @path = XML::XXPath.new(path)
      args
    end

    def extract_attr_value(xml) # :nodoc:
      value = default_when_xpath_err{ @path.first(xml).text }
      value ? Time.iso8601(value).utc : nil
    end

    def set_attr_value(xml, value) # :nodoc:
      @path.first(xml,:ensure_created=>true).text = value.to_s
    end
  end

  XML::Mapping.add_node_class TimeNode

  class UriNode < XML::Mapping::SingleAttributeNode
    def initialize(*args)
      path, *args = super(*args)
      @path = XML::XXPath.new(path)
      args
    end

    def extract_attr_value(xml) # :nodoc:
      URI(default_when_xpath_err{ @path.first(xml).text })
    end
    def set_attr_value(xml, value) # :nodoc:
      @path.first(xml,:ensure_created=>true).text = value.to_s
    end
  end

  XML::Mapping.add_node_class UriNode

  Dir.glob(File.expand_path('../resync/*.rb', __FILE__), &method(:require))
end

# require 'bigdecimal'
#
# module HappyMapper
#   module SupportedTypes
#     register_type URI do |value|
#       URI(value)
#     end
#
#     register_type Resync::Change do |value|
#       Resync::Change.parse(value)
#     end
#
#     register_type Resync::Changefreq do |value|
#       Resync::Changefreq.parse(value)
#     end
#   end
# end
