require_relative 'base_resource_list_examples'

module Resync

  RSpec.shared_examples SortedResourceList do

    # ------------------------------------------------------
    # Superclass conformance

    it_behaves_like BaseResourceList

    def new_instance(**args)
      required_args = (defined? required_arguments) ? required_arguments : {}
      args = required_args.merge(args)
      described_class.new(**args)
    end

    # ------------------------------------------------------
    # Tests

    describe '#new' do

      describe 'resources' do
        it 'sorts resources by modified_time' do
          resource0 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1997, 7, 16, 19, 20, 30.45))
          resource1 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1998, 7, 16, 19, 20, 30.45))
          list = new_instance(resources: [resource1, resource0])
          expect(list.resources).to eq([resource0, resource1])
        end

        it 'sorts resources with modified_time before resources without' do
          resource0 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1997, 7, 16, 19, 20, 30.45))
          resource1 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1998, 7, 16, 19, 20, 30.45))
          resource2 = Resource.new(uri: 'http://example.com')
          list = new_instance(resources: [resource1, resource2, resource0])
          expect(list.resources).to eq([resource0, resource1, resource2])
        end
      end

    end

  end

end
