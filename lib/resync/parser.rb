require 'nokogiri'

module Resync
  class Parser

    # ------------------------------
    # Public methods

    def self.parse(xml)

      root = case xml
             when Nokogiri::XML::Document
               xml.root
             when Nokogiri::XML::Element
               xml
             when String
               Nokogiri::XML(xml).root
             else
               fail "Unexpected argument type: #{xml.class}"
             end

      parse_class = get_parse_class(root)
      parse_class.parse(xml, single: true)
    end

    # ------------------------------
    # Private methods

    private

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
  end
end
