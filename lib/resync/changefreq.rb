require 'ruby-enum'

module Resync
  class Changefreq
    include Ruby::Enum

    define :ALWAYS, 'always'
    define :HOURLY, 'hourly'
    define :DAILY, 'daily'
    define :WEEKLY, 'weekly'
    define :MONTHLY, 'monthly'
    define :YEARLY, 'yearly'
    define :NEVER, 'never'
  end

  class ChangefreqNode < XML::Mapping::SingleAttributeNode
    def initialize(*args)
      path, *args = super(*args)
      @path = XML::XXPath.new(path)
      args
    end

    def extract_attr_value(xml) # :nodoc:
      Changefreq.parse(default_when_xpath_err { @path.first(xml).text })
    end

    def set_attr_value(xml, value) # :nodoc:
      @path.first(xml, ensure_created: true).text = value.to_s
    end
  end

  XML::Mapping.add_node_class ChangefreqNode

end
