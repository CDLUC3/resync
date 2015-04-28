require 'nokogiri'

module Resync
  module Parser

    module_function

    def parse(xml)
      doc = Nokogiri::XML(xml)
      parse_class = case doc.root.name.downcase
                    when 'urlset'
                      Urlset
                    when 'sitemapindex'
                      Sitemapindex
                    end
      parse_class.parse(xml, single: true)
    end
  end
end
