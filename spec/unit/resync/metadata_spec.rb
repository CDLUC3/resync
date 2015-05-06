require 'spec_helper'

module Resync
  describe Metadata do
    describe '#new' do

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

    end
  end
end
