require 'happymapper'

module Resync
  Dir.glob(File.expand_path('../resync/*.rb', __FILE__), &method(:require))
end

require 'bigdecimal'

module HappyMapper
  module SupportedTypes
    register_type BigDecimal do |value|
      BigDecimal.new(value)
    end

    register_type URI do |value|
      URI(value)
    end

    register_type Resync::Change do |value|
      Change.parse(value)
    end

    register_type Resync::Changefreq do |value|
      Changefreq.parse(value)
    end
  end
end
