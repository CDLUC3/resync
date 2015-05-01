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
    end
  end

  def to_string(xml)
    return nil unless xml
    formatter = REXML::Formatters::Pretty.new(2)
    formatter.compact = true
    out = StringIO.new
    formatter.write(xml, out)
    out.string
  end

  match do |actual|
    expected_xml = to_element(expected) || fail("expected value #{expected} does not appear to be XML")
    actual_xml = to_element(actual)
    to_string(actual_xml) == to_string(expected_xml)
  end

  failure_message do |actual|
    expected_string = to_string(to_element(expected))
    actual_string = to_string(to_element(actual)) || actual
    "expected XML:\n#{expected_string}\n\nbut was:\n#{actual_string}"
  end

  failure_message_when_negated do |actual|
    actual_xml = to_element(actual) || actual
    "expected not to get XML:\n\t#{actual_xml}"
  end
end
