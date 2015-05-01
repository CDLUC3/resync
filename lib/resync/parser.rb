require 'rexml/document'

module Resync
  class Parser

    # ------------------------------
    # Public methods

    # @return [Urlset, Sitemapindex]
    def self.parse(xml)
      root = find_root(xml)
      parse_class = get_parse_class(root)
      parse_class.load_from_xml(root)
    end

    # ------------------------------
    # Private methods

    def self.find_root(xml)
      case xml
      when String
        REXML::Document.new(xml).root
      when REXML::Document
        xml.root
      when REXML::Element
        xml
      else
        fail "Unexpected argument type; expected XML document, was #{xml.class}"
      end
    end

    def self.get_parse_class(root)
      root_name = root.name
      case root_name.downcase
      when 'urlset'
        Urlset
      when 'sitemapindex'
        Sitemapindex
      else
        fail "Unexpected root tag <#{root_name}>"
      end
    end

    private_class_method :get_parse_class

  end
end
