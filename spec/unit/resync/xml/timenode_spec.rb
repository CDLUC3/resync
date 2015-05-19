require 'spec_helper'

module Resync
  module XML

    class Elem
      include XML::Mapped
      time_node :time, '@time', default_value: nil

      def self.from_str(time_str)
        xml_string = "<elem time='#{time_str}'/>"
        doc = REXML::Document.new(xml_string)
        load_from_xml(doc.root)
      end
    end

    describe TimeNode do

      def time(str)
        Elem.from_str(str).time
      end

      it 'parses a date with hours, minutes, and seconds' do
        actual = time('1997-07-16T19:20:30')
        expected = Time.new(1997, 7, 16, 19, 20, 30)
        expect(actual).to be_time(expected)
      end

      it 'parses a date with hours, minutes, seconds, and fractional seconds' do
        actual = time('1997-07-16T19:20:30.45')
        expected = Time.new(1997, 7, 16, 19, 20, 30.45)
        expect(actual).to be_time(expected)
      end

      it 'parses a UTC "zulu" time (time zone designator "Z")' do
        actual = time('1997-07-16T19:20:30.45Z')
        expected = Time.new(1997, 7, 16, 19, 20, 30.45, '+00:00')
        expect(actual).to be_time(expected)
      end

      it 'parses a time with a numeric timezone offset' do
        actual = time('1997-07-16T19:20:30.45+01:30')
        expected = Time.new(1997, 7, 16, 19, 20, 30.45, '+01:30')
        expect(actual).to be_time(expected)
      end
    end
  end
end
