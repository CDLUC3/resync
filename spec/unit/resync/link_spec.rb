require 'spec_helper'
require_relative 'shared/uri_field_examples'
require_relative 'shared/resource_descriptor_examples'

module Resync
  describe Link do

    def required_arguments
      { rel: 'describedby', href: 'http://example.org' }
    end

    it_behaves_like ResourceDescriptor

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
        def uri_field
          :href
        end
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

    end

  end
end
