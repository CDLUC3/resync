module Resync
  Dir.glob(File.expand_path('../resync/*.rb', __FILE__), &method(:require))
end

require 'bigdecimal'

module HappyMapper
  module SupportedTypes
    register_type BigDecimal do |value|
      BigDecimal.new(value)
    end
  end
end
