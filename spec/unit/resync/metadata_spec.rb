require 'spec_helper'

module Resync
  describe Metadata do
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

        it 'accepts a modified timestamp' do
          modified_time = Time.utc(1997, 7, 16, 19, 20, 30.45)
          metadata = Metadata.new(modified_time: modified_time)
          expect(metadata.modified_time).to be_time(modified_time)
        end

        it 'defaults to nil if no modified timestamp is specified' do
          metadata = Metadata.new
          expect(metadata.modified_time).to be_nil
        end

        it 'fails if the modified timestamp is not a time' do
          expect { Metadata.new(modified_time: '12:45 pm') }.to raise_error(ArgumentError)
        end

      end

      describe 'length' do
        it 'accepts a length' do
          length = 12_345
          metadata = Metadata.new(length: length)
          expect(metadata.length).to eq(length)
        end

        it 'defaults to nil if no length is specified' do
          metadata = Metadata.new
          expect(metadata.length).to be_nil
        end

        it 'fails if length is not a non-negative integer' do
          expect { Metadata.new(length: -12_345) }.to raise_error(ArgumentError)
          expect { Metadata.new(length: 123.45) }.to raise_error(ArgumentError)
          expect { Metadata.new(length: 'I am not a number') }.to raise_error(ArgumentError)
        end
      end

      describe 'mime_type' do
        it 'accepts a standard MIME type' do
          mt = MIME::Types['text/plain'].first
          metadata = Metadata.new(mime_type: mt)
          expect(metadata.mime_type).to eq(mt)
        end

        it 'accepts a non-standard MIME type' do
          mt = MIME::Type.new('elvis/presley')
          metadata = Metadata.new(mime_type: mt)
          expect(metadata.mime_type).to eq(mt)
        end

        it 'accepts a MIME type as a string' do
          mt_string = 'elvis/presley'
          metadata = Metadata.new(mime_type: mt_string)
          expect(metadata.mime_type).to eq(MIME::Type.new(mt_string))
        end

        it 'defaults to nil if no MIME type is specified' do
          metadata = Metadata.new
          expect(metadata.length).to be_nil
        end

        it 'fails if mime_type isn\'t a MIME type' do
          mt_string = 'I am not a mime type'
          expect { Metadata.new(mime_type: mt_string) }.to raise_error(MIME::Type::InvalidContentType)
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

      describe 'hash' do
        # see e.g. spec Example 14
        it 'allows hash access by algorithm'
        it 'allows multiple hashes with different algorithms'
      end

    end
  end
end
