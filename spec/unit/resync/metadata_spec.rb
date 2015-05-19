require 'spec_helper'
require_relative 'shared/resource_descriptor_examples'

module Resync
  describe Metadata do

    it_behaves_like ResourceDescriptor

    describe '#new' do

      describe 'timestamps' do

        # TODO: Find a way to share the examples for the different time attributes
        it 'accepts an at timestamp' do
          at_time = Time.utc(1997, 7, 16, 19, 20, 30.45)
          metadata = Metadata.new(at_time: at_time)
          expect(metadata.at_time).to be_time(at_time)
        end

        it 'defaults to nil if no at timestamp is specified' do
          metadata = Metadata.new
          expect(metadata.at_time).to be_nil
        end

        it 'fails if the at timestamp is not a time' do
          expect { Metadata.new(at_time: '12:45 pm') }.to raise_error(ArgumentError)
        end

        it 'accepts a from timestamp' do
          from_time = Time.utc(1997, 7, 16, 19, 20, 30.45)
          metadata = Metadata.new(from_time: from_time)
          expect(metadata.from_time).to be_time(from_time)
        end

        it 'defaults to nil if no from timestamp is specified' do
          metadata = Metadata.new
          expect(metadata.from_time).to be_nil
        end

        it 'fails if the from timestamp is not a time' do
          expect { Metadata.new(from_time: '12:45 pm') }.to raise_error(ArgumentError)
        end

        it 'accepts an until timestamp' do
          until_time = Time.utc(1997, 7, 16, 19, 20, 30.45)
          metadata = Metadata.new(until_time: until_time)
          expect(metadata.until_time).to be_time(until_time)
        end

        it 'defaults to nil if no until timestamp is specified' do
          metadata = Metadata.new
          expect(metadata.until_time).to be_nil
        end

        it 'fails if the until timestamp is not a time' do
          expect { Metadata.new(until_time: '12:45 pm') }.to raise_error(ArgumentError)
        end

        it 'accepts a completed timestamp' do
          completed_time = Time.utc(1997, 7, 16, 19, 20, 30.45)
          metadata = Metadata.new(completed_time: completed_time)
          expect(metadata.completed_time).to be_time(completed_time)
        end

        it 'defaults to nil if no completed timestamp is specified' do
          metadata = Metadata.new
          expect(metadata.completed_time).to be_nil
        end

        it 'fails if the completed timestamp is not a time' do
          expect { Metadata.new(completed_time: '12:45 pm') }.to raise_error(ArgumentError)
        end

      end

      describe 'capability' do
        it 'accepts a capability' do
          cap = 'resourcelist'
          metadata = Metadata.new(capability: cap)
          expect(metadata.capability).to eq(cap)
        end

        it 'defaults to nil if no capability specified' do
          metadata = Metadata.new
          expect(metadata.capability).to be_nil
        end
      end

      describe 'change' do
        it 'accepts a change' do
          change = Types::Change::DELETED
          metadata = Metadata.new(change: change)
          expect(metadata.change).to eq(change)
        end

        it 'defaults to nil if no change specified' do
          metadata = Metadata.new
          expect(metadata.change).to be_nil
        end
      end
    end

    describe 'XML conversion' do
      describe '#from_xml' do
        it 'parses an XML string' do
          xml = '<md
                at="2001-01-01T01:00:00Z"
                capability="resourcelist"
                change="updated"
                completed="2002-02-02T02:00:00Z"
                encoding="utf-16"
                from="2003-03-03T03:00:00Z"
                hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"
                length="54321"
                modified="2004-04-04T04:00:00Z"
                path="/foo"
                type="bar/baz"
                until="2005-05-05T05:00:00Z"
            />'
          metadata = Metadata.from_xml(xml)
          expect(metadata).to be_a(Metadata)
          expect(metadata.at_time).to be_time(Time.utc(2001, 1, 1, 1))
          expect(metadata.capability).to eq('resourcelist')
          expect(metadata.change).to eq(Types::Change::UPDATED)
          expect(metadata.completed_time).to be_time(Time.utc(2002, 2, 2, 2))
          expect(metadata.encoding).to eq('utf-16')
          expect(metadata.from_time).to be_time(Time.utc(2003, 3, 3, 3))
          expect(metadata.hash('md5')).to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
          expect(metadata.length).to eq(54_321)
          expect(metadata.modified_time).to be_time(Time.utc(2004, 4, 4, 4))
          expect(metadata.path).to eq('/foo')
          expect(metadata.mime_type).to be_mime_type('bar/baz')
          expect(metadata.until_time).to be_time(Time.utc(2005, 5, 5, 5))
        end

        it 'can round-trip to XML with namespaces' do
          data = '<rs:md
                at="2001-01-01T01:00:00Z"
                capability="resourcelist"
                change="updated"
                completed="2002-02-02T02:00:00Z"
                encoding="utf-16"
                from="2003-03-03T03:00:00Z"
                hash="md5:1e0d5cb8ef6ba40c99b14c0237be735e"
                length="54321"
                modified="2004-04-04T04:00:00Z"
                path="/foo"
                type="bar/baz"
                until="2005-05-05T05:00:00Z"
            />'
          md = Metadata.from_xml(data)
          xml = md.save_to_xml
          expect(xml).to be_xml(data)
        end
      end
    end
  end
end
