require 'happymapper'
require 'uri'

module Resync
  class Ln
    include HappyMapper

    tag 'ln'
    namespace 'rs'

    attribute :encoding, String
    attribute :hash, String
    attribute :href, URI
    attribute :length, Integer
    attribute :modified, DateTime
    attribute :path, String
    attribute :pri, Integer
    attribute :rel, String
    attribute :type, String
  end
end
