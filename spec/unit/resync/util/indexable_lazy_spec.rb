require 'spec_helper'

module Resync
  module Util
    describe IndexableLazy do

      before(:each) do
        @size = 3
        @array = Array.new(@size) { instance_double(Object) }
        @lazy = IndexableLazy.new(@array)
      end

      describe '#size' do
        it 'returns the size of the underlying array' do
          expect(@lazy.size).to eq(@size)
        end
      end

      describe '#[]' do
        it 'is lazy' do
          expect(@array[0]).to receive(:to_s).and_return('0')
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          (0...@lazy.size).each do |i|
            expect(@lazy[i]).to eq(@array[i])
            break if @lazy[i].to_s == '1'
          end
        end
      end

      describe '#each' do
        it 'is lazy' do
          expect(@array[0]).to receive(:to_s).and_return('0')
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          @lazy.each do |v|
            break if v.to_s == '1'
          end
        end
      end

      describe '#each_with_index' do
        it 'is lazy' do
          expect(@array[0]).to receive(:to_s).and_return('0')
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          @lazy.each_with_index do |v, i|
            break if v.to_s == '1' || i > 1
          end
        end
      end

      describe '#each_with_object' do
        it 'is lazy' do
          expect(@array[0]).to receive(:to_s).and_return('0')
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          acc = []
          @lazy.each_with_object(acc) do |v, obj|
            obj << v.to_s
            break if obj[-1] == '1'
          end
          expect(acc).to eq(%w(0 1))
        end
      end

      describe '#find' do
        it 'is lazy' do
          expect(@array[0]).to receive(:to_s).and_return('0')
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          expect(@lazy.find { |v| v.to_s == '1' }).to be(@array[1])
        end
      end

      describe '#find_index' do
        it 'is lazy' do
          expect(@array[0]).to receive(:to_s).and_return('0')
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          expect(@lazy.find_index { |v| v.to_s == '1' }).to eq(1)
        end
      end

      describe '#take_while' do
        it 'is lazy' do
          expect(@array[0]).to receive(:to_s).and_return('0')
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          expect(@lazy.take_while { |v| v.to_s == '0' }.to_a).to eq([@array[0]])
        end
      end

      describe '#map' do
        it 'is lazy' do
          expect(@array[0]).to receive(:to_s).and_return('0')
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          mapped = @lazy.map(&:to_s)
          expect(mapped.take(2).to_a).to eq(%w(0 1))
        end

        it 'supports indexing' do
          expect(@array[0]).not_to receive(:to_s)
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          mapped = @lazy.map(&:to_s)
          expect(mapped[1]).to eq('1')
        end
      end

      describe '#take' do
        it 'is lazy' do
          expect(@array[0]).to receive(:to_s).and_return('0')
          expect(@array[1]).to receive(:to_s).and_return('1')
          expect(@array[2]).not_to receive(:to_s)

          expect(@lazy.take(2).map(&:to_s).to_a).to eq(%w(0 1))
        end
      end

      describe '#select' do
        it 'is lazy' do
          expect(@array[0]).not_to receive(:to_s)
          expect(@array[1]).not_to receive(:to_s)
          expect(@array[2]).not_to receive(:to_s)

          @lazy.select(&:to_s)
        end
      end
    end
  end
end
