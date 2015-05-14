require 'xml/mapping'

module Resync
  module XML
    class Md
      include ::XML::Mapping

      time_node :at_time, '@at', default_value: nil
      time_node :from_time, '@from', default_value: nil
      time_node :until_time, '@until', default_value: nil
      time_node :completed_time, '@completed', default_value: nil
      time_node :modified_time, '@modified', default_value: nil

      numeric_node :length, '@length', default_value: nil
      mime_type_node :mime_type, '@type', default_value: nil
      text_node :encoding, '@encoding', default_value: nil
      hash_codes_node :hashes, '@hash', default_value: nil

      change_node :change, '@change', default_value: nil
      text_node :capability, '@capability', default_value: nil
      text_node :path, '@path', default_value: nil

    end
  end
end
