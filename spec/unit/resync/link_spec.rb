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
    end

  end
end
