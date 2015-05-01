require 'xml/mapping'

module Resync
  class Md
    include XML::Mapping

    time_node :at, '@at', default_value: nil
    text_node :capability, '@capability', default_value: nil
    change_node :change, '@change', default_value: nil
    time_node :completed, '@completed', default_value: nil
    text_node :encoding, '@encoding', default_value: nil
    time_node :from, '@from', default_value: nil
    text_node :_hash, '@hash', default_value: nil
    numeric_node :length, '@length', default_value: nil
    time_node :modified, '@modified', default_value: nil
    text_node :path, '@path', default_value: nil
    text_node :type, '@type', default_value: nil
    time_node :until, '@until', default_value: nil

    def hash
      _hash
    end

  end
end
