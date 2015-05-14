require 'xml/mapping'
require 'uri'

module Resync
  module XML
    class Ln
      include ::XML::Mapping

      text_node :rel, '@rel', default_value: nil
      uri_node :href, '@href', default_value: nil

      numeric_node :pri, '@pri', default_value: nil

      time_node :modified, '@modified', default_value: nil

      numeric_node :length, '@length', default_value: nil
      mime_type_node :type, '@type', default_value: nil
      text_node :encoding, '@encoding', default_value: nil
      hash_codes_node :hashes, '@hash', default_value: nil

      text_node :path, '@path', default_value: nil
    end
  end
end
