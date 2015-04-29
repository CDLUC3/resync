require 'happymapper'

module Resync
  class Urlset
    include HappyMapper

    tag 'urlset'

    has_many :url, Url

    element :md, Md
    has_many :ln, Ln
  end
end
