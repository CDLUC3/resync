require_relative 'list_base_spec'

module Resync

  RSpec.shared_examples SortedListBase do

    # ------------------------------------------------------
    # Superclass conformance

    it_behaves_like ListBase

    # TODO: Figure out how to share this with ListBase (use RSpec helper methods?)
    def new_list(**args)
      if defined? new_list_override
        new_list_override(**args)
      else
        described_class.new(**args)
      end
    end

    # ------------------------------------------------------
    # Tests

    describe '#new' do

      describe 'resources' do
        it 'sorts resources by lastmod' do
          resource0 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1997, 7, 16, 19, 20, 30.45))
          resource1 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1998, 7, 16, 19, 20, 30.45))
          list = new_list(resources: [resource1, resource0])
          expect(list.resources).to eq([resource0, resource1])
        end

        it 'sorts resources with lastmod before resources without' do
          resource0 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1997, 7, 16, 19, 20, 30.45))
          resource1 = Resource.new(uri: 'http://example.org', lastmod: Time.utc(1998, 7, 16, 19, 20, 30.45))
          resource2 = Resource.new(uri: 'http://example.com')
          list = new_list(resources: [resource1, resource2, resource0])
          expect(list.resources).to eq([resource0, resource1, resource2])
        end
      end

      # TODO: Figure out what concrete types this was intended for, and test it
      describe 'metadata' do
        it 'requires from and until times (?)'
      end
    end

  end

end
