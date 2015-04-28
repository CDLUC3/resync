require 'bigdecimal'
require 'happymapper'

module Resync
  class Url
    include HappyMapper

    tag 'url'

    element :loc, URI
    element :lastmod, DateTime
    element :changefreq, Changefreq
    element :priority, BigDecimal

    element :md, Md
    has_many :ln, Ln
  end
end
