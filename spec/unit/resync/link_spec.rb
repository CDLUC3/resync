require 'spec_helper'
require_relative 'shared/uri_field_examples'

module Resync
  describe Link do

    describe '#new' do

      describe 'rel' do
        it 'accepts a relation' do
          rel = 'describedby'
          link = Link.new(rel: rel, href: 'http://example.org')
          expect(link.rel).to eq(rel)
        end

        it 'requires a relation' do
          expect { Link.new(href: 'http://example.org') }.to raise_error(ArgumentError)
        end
      end

      describe 'href' do
        def required_arguments; { rel: 'describedby' }; end # rubocop:disable Style/SingleLineMethods

        def uri_field; :href; end # rubocop:disable Style/SingleLineMethods
        it_behaves_like 'a URI field'
      end

      describe 'priority' do
        it 'accepts a priority' do
          priority = 1.234
          link = Link.new(rel: 'describedby', href: 'http://example.org', priority: priority)
          expect(link.priority).to eq(priority)
        end

        it 'defaults to nil if no priority specified' do
          link = Link.new(rel: 'describedby', href: 'http://example.org')
          expect(link.priority).to be_nil
        end
      end

      describe 'modified_time' do
        it 'accepts a modified_time' do
          modified_time = Time.utc(2014, 5, 17, 1, 2, 3)
          link = Link.new(rel: 'describedby', href: 'http://example.org', modified_time: modified_time)
          expect(link.modified_time).to eq(modified_time)
        end

        it 'defaults to nil if no modified_time specified' do
          link = Link.new(rel: 'describedby', href: 'http://example.org')
          expect(link.modified_time).to be_nil
        end
      end

      describe 'length' do
        it 'accepts a length' do
          length = 1234
          link = Link.new(rel: 'describedby', href: 'http://example.org', length: length)
          expect(link.length).to eq(length)
        end

        it 'defaults to nil if no length specified' do
          link = Link.new(rel: 'describedby', href: 'http://example.org')
          expect(link.length).to be_nil
        end
      end

      # TODO: share examples with Metadata
      describe 'mime_type' do
        it 'accepts a standard MIME type' do
          mt = MIME::Types['text/plain'].first
          link = Link.new(rel: 'describedby', href: 'http://example.org', mime_type: mt)
          expect(link.mime_type).to eq(mt)
        end

        it 'accepts a non-standard MIME type' do
          mt = MIME::Type.new('elvis/presley')
          link = Link.new(rel: 'describedby', href: 'http://example.org', mime_type: mt)
          expect(link.mime_type).to eq(mt)
        end

        it 'accepts a MIME type as a string' do
          mt_string = 'elvis/presley'
          link = Link.new(rel: 'describedby', href: 'http://example.org', mime_type: mt_string)
          expect(link.mime_type).to eq(MIME::Type.new(mt_string))
        end

        it 'defaults to nil if no MIME type is specified' do
          link = Link.new(rel: 'describedby', href: 'http://example.org')
          expect(link.length).to be_nil
        end

        it 'fails if mime_type isn\'t a MIME type' do
          mt_string = 'I am not a mime type'
          expect { Link.new(rel: 'describedby', href: 'http://example.org', mime_type: mt_string) }.to raise_error(MIME::Type::InvalidContentType)
        end
      end

      describe 'encoding' do
        it 'accepts an encoding' do
          encoding = 'utf-8'
          link = Link.new(rel: 'describedby', href: 'http://example.org', encoding: encoding)
          expect(link.encoding).to eq(encoding)
        end

        it 'defaults to nil if no encoding specified' do
          link = Link.new(rel: 'describedby', href: 'http://example.org')
          expect(link.encoding).to be_nil
        end
      end

      describe 'hash' do
        it 'accepts a hash of hashes' do
          hashes = {
            'md5' => '1e0d5cb8ef6ba40c99b14c0237be735e',
            'sha-256' => '854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784'
          }
          link = Link.new(rel: 'describedby', href: 'http://example.org', hashes: hashes)
          expect(link.hashes).to eq(hashes)
          expect(link.hash('md5')). to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
          expect(link.hash('sha-256')). to eq('854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784')
        end

        it 'defaults to an empty hash if no hash specified' do
          link = Link.new(rel: 'describedby', href: 'http://example.org')
          expect(link.hashes).to eq({})
        end
      end

      describe 'path' do
        it 'accepts a path' do
          path = '/resources/res2'
          link = Link.new(rel: 'describedby', href: 'http://example.org', path: path)
          expect(link.path).to eq(path)
        end

        it 'defaults to nil if no path specified' do
          link = Link.new(rel: 'describedby', href: 'http://example.org')
          expect(link.path).to be_nil
        end
      end
    end

  end
end
