require 'happymapper'

module Resync
  class Urlset
    include HappyMapper

    tag 'urlset'

    # has_many :any, Any
    has_many :url, Url
  end
end
