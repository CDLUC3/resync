require 'rspec/expectations'

RSpec::Matchers.define :be_xml do |expected|

  def to_element(xml)
    case xml
    when String
      REXML::Document.new(xml).root
    when REXML::Document
      xml.root
    when REXML::Element
      xml
    else
      nil
    end
  end

  match do |actual|
    expected_xml = to_element(expected) || fail("expected value #{expected} does not appear to be XML")
    actual_xml = to_element(actual)
    actual_xml.to_s == expected_xml.to_s
  end

  failure_message do |actual|
    expected_xml = to_element(expected)
    actual_xml = to_element(actual) || actual
    "expected xml:\n\t#{expected_xml.to_s}\nbut was:\n\t#{actual_xml.to_s}"
  end
end
