require 'ruby-enum'

module Resync
  class Change
    include Ruby::Enum

    define :CREATED, 'created'
    define :UPDATED, 'updated'
    define :DELETED, 'deleted'
  end

  class ChangeNode < XML::Mapping::SingleAttributeNode
    def initialize(*args)
      path, *args = super(*args)
      @path = XML::XXPath.new(path)
      args
    end

    def extract_attr_value(xml) # :nodoc:
      Change.parse(default_when_xpath_err { @path.first(xml).text })
    end

    def set_attr_value(xml, value) # :nodoc:
      @path.first(xml, ensure_created: true).text = value.to_s
    end
  end

  XML::Mapping.add_node_class ChangeNode
end
