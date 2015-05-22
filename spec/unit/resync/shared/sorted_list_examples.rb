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

    describe '#resources_by_uri' do
      it 'groups resources by uri' do
        resource0 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1997, 7, 16, 19, 20, 30.45))
        resource1 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1998, 7, 16, 19, 20, 30.45))
        resource2 = Resource.new(uri: 'http://example.com', modified_time: Time.utc(1994, 7, 16, 19, 20, 30.45))
        resource3 = Resource.new(uri: 'http://example.com', modified_time: Time.utc(1995, 7, 16, 19, 20, 30.45))
        list = new_instance(resources: [resource0, resource1, resource2, resource3])

        by_uri = list.resources_by_uri
        expect(by_uri.size).to eq(2)

        uri0 = by_uri.keys[0]
        expect(uri0).to eq(URI('http://example.com'))
        rs0 = by_uri[uri0]
        expect(rs0).to eq([resource2, resource3])

        uri1 = by_uri.keys[1]
        expect(uri1).to eq(URI('http://example.org'))
        rs1 = by_uri[uri1]
        expect(rs1).to eq([resource0, resource1])
      end

      it 'updates when the list is updated' do
        list = new_instance
        expect(list.resources_by_uri).to eq({})

        resource0 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1997, 7, 16, 19, 20, 30.45))
        list.resources = [resource0]

        by_uri = list.resources_by_uri
        expect(by_uri.size).to eq(1)
        rs0 = by_uri[URI('http://example.org')]
        expect(rs0).to eq([resource0])
      end
    end

    describe '#latest_for' do
      it 'retrieves the last-modified-instance for a specified URI' do
        resource0 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1997, 7, 16, 19, 20, 30.45))
        resource1 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1998, 7, 16, 19, 20, 30.45))
        resource2 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1994, 7, 16, 19, 20, 30.45))
        resource3 = Resource.new(uri: 'http://example.com', modified_time: Time.utc(1995, 7, 16, 19, 20, 30.45))
        resource4 = Resource.new(uri: 'http://example.com', modified_time: Time.utc(2003, 7, 16, 19, 20, 30.45))
        list = new_instance(resources: [resource0, resource1, resource2, resource3, resource4])

        expect(list.latest_for(uri: URI('http://example.org'))).to eq(resource1)
        expect(list.latest_for(uri: 'http://example.com')).to eq(resource4)
      end
    end

    describe '#all_uris' do
      it 'retrieves the set of all URIs' do
        resource0 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1997, 7, 16, 19, 20, 30.45))
        resource1 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1998, 7, 16, 19, 20, 30.45))
        resource2 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1994, 7, 16, 19, 20, 30.45))
        resource3 = Resource.new(uri: 'http://example.com', modified_time: Time.utc(1995, 7, 16, 19, 20, 30.45))
        resource4 = Resource.new(uri: 'http://example.com', modified_time: Time.utc(2003, 7, 16, 19, 20, 30.45))
        list = new_instance(resources: [resource0, resource1, resource2, resource3, resource4])
        expect(list.all_uris).to eq([URI('http://example.org'), URI('http://example.com')])
      end
    end
  end

end
