require 'happymapper'
require 'bigdecimal'

module HappyMapper
  module SupportedTypes
    register_type BigDecimal do |value|
      BigDecimal.new(value)
    end

    register_type URI do |value|
      URI(value)
    end
  end
end

module Resync
  Dir.glob(File.expand_path('../resync/*.rb', __FILE__), &method(:require))
end

