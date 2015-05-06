require 'xml/mapping'
require 'time'

module Resync
  module XML

    class TimeNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      def extract_attr_value(xml)
        value = default_when_xpath_err { @path.first(xml).text }
        value ? Time.iso8601(value).utc : nil
      end

      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.iso8601
      end
    end

    ::XML::Mapping.add_node_class TimeNode

    class UriNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      def extract_attr_value(xml)
        URI(default_when_xpath_err { @path.first(xml).text })
      end

      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.to_s
      end
    end

    ::XML::Mapping.add_node_class UriNode

    class ChangeNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      def extract_attr_value(xml)
        Resync::Types::Change.parse(default_when_xpath_err { @path.first(xml).text })
      end

      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.to_s
      end
    end

    ::XML::Mapping.add_node_class ChangeNode

    class ChangefreqNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      def extract_attr_value(xml)
        Resync::Types::ChangeFrequency.parse(default_when_xpath_err { @path.first(xml).text })
      end

      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.to_s
      end
    end

    ::XML::Mapping.add_node_class ChangefreqNode

    class MimeTypeNode < ::XML::Mapping::SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      def extract_attr_value(xml)
        mime_type = default_when_xpath_err { @path.first(xml).text }
        return nil unless mime_type
        return mime_type if mime_type.is_a?(MIME::Type)

        mt = MIME::Types[mime_type].first
        return mt if mt

        MIME::Type.new(mime_type)
      end

      def set_attr_value(xml, value)
        @path.first(xml, ensure_created: true).text = value.to_s
      end
    end

    ::XML::Mapping.add_node_class MimeTypeNode
  end
end
