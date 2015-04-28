require 'happymapper'

module Resync
  class Ln
    include HappyMapper

    tag 'ln'

    attribute :encoding, String
    attribute :hash, String
    attribute :href, String
    attribute :length, Integer
    attribute :modified, DateTime
    attribute :path, String
    attribute :pri, Integer
    attribute :rel, String
    attribute :type, String
  end
end
