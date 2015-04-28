require 'happymapper'

module Resync
  class Urlset
    include HappyMapper

    tag 'urlset'

    has_many :url, Url

    element :md, Md
  end
end
