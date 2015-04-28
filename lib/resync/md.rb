require 'happymapper'

module Resync
  class Md
    include HappyMapper

    tag 'md'

    attribute :at, DateTime
    attribute :capability, String
    attribute :change, String # ChangeType
    attribute :completed, DateTime
    attribute :encoding, String
    attribute :from, DateTime
    attribute :hash, String
    attribute :length, Integer
    attribute :modified, DateTime
    attribute :path, String
    attribute :type, String
    attribute :until, DateTime
  end
end
