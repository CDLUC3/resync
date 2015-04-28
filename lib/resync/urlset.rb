require 'happymapper'

module Resync
  class Urlset < NamespacedElement
    # include HappyMapper

    tag 'urlset'

    # has_many :any, Any
    has_many :url, Url
    element :md, Md

    def self.namespace_uri
      URI('http://www.sitemaps.org/schemas/sitemap/0.9')
    end
  end
end
