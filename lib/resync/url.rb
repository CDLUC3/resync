require 'bigdecimal'
require 'happymapper'

module Resync
  class Url
    include HappyMapper

    tag 'url'

    element :loc, URI
    element :lastmod, String
    element :changefreq, String # TChangeFreq
    element :priority, BigDecimal
    # has_many :any, Any
  end
end
