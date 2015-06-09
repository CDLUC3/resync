require_relative 'sorted_list_examples'

module Resync
  RSpec.shared_examples BaseChangeList do

    # ------------------------------------------------------
    # Superclass conformance

    it_behaves_like SortedResourceList

    def new_instance(**args)
      required_args = (defined? required_arguments) ? required_arguments : {}
      args = required_args.merge(args)
      described_class.new(**args)
    end

    # ------------------------------------------------------
    # Tests

    describe '#changes' do

      it 'returns all changes if called without arguments' do
        resource0 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1997, 7, 16, 19, 20, 30.45))
        resource1 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1998, 7, 16, 19, 20, 30.45))
        resource2 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1998, 8, 16, 19, 20, 30.45))
        resource3 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1999, 1, 16, 19, 20, 30.45))
        list = new_instance(resources: [resource1, resource3, resource2, resource0])
        expect(list.changes.to_a).to eq([resource0, resource1, resource2, resource3])
      end

      it 'filters on change type' do
        resource0 = Resource.new(uri: 'http://example.org', metadata: Metadata.new(change: Types::Change::CREATED), modified_time: Time.utc(1997, 7, 16, 19, 20, 30.45))
        resource1 = Resource.new(uri: 'http://example.org', metadata: Metadata.new(change: Types::Change::UPDATED), modified_time: Time.utc(1998, 7, 16, 19, 20, 30.45))
        resource2 = Resource.new(uri: 'http://example.org', metadata: Metadata.new(change: Types::Change::UPDATED), modified_time: Time.utc(1998, 8, 16, 19, 20, 30.45))
        resource3 = Resource.new(uri: 'http://example.org', metadata: Metadata.new(change: Types::Change::DELETED), modified_time: Time.utc(1999, 1, 16, 19, 20, 30.45))
        list = new_instance(resources: [resource0, resource1, resource2, resource3])
        changes = list.changes(of_type: Types::Change::UPDATED)
        expect(changes.to_a).to eq([resource1, resource2])
      end

      it 'filters on modified time' do
        resource0 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1997, 7, 16, 19, 20, 30.45))
        resource1 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1998, 7, 16, 19, 20, 30.45))
        resource2 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1998, 8, 16, 19, 20, 30.45))
        resource3 = Resource.new(uri: 'http://example.org', modified_time: Time.utc(1999, 1, 16, 19, 20, 30.45))
        list = new_instance(resources: [resource0, resource1, resource2, resource3])
        range = Time.utc(1998, 1, 1)...Time.utc(1999, 1, 1)
        changes = list.changes(in_range: range)
        expect(changes.to_a).to eq([resource1, resource2])
      end

      it 'filters on combinations' do
        resources = []
        resources[0] = Resource.new(uri: 'http://example.org/', modified_time: Time.utc(1999, 1, 1), metadata: Metadata.new(change: Types::Change::CREATED))
        resources[1] = Resource.new(uri: 'http://example.org/', modified_time: Time.utc(2000, 1, 1), metadata: Metadata.new(change: Types::Change::CREATED))
        resources[2] = Resource.new(uri: 'http://example.org/', modified_time: Time.utc(1999, 3, 1), metadata: Metadata.new(change: Types::Change::UPDATED))
        resources[3] = Resource.new(uri: 'http://example.org/', modified_time: Time.utc(1999, 6, 1), metadata: Metadata.new(change: Types::Change::UPDATED))
        resources[4] = Resource.new(uri: 'http://example.org/', modified_time: Time.utc(2000, 3, 1), metadata: Metadata.new(change: Types::Change::UPDATED))
        resources[5] = Resource.new(uri: 'http://example.org/', modified_time: Time.utc(2000, 6, 1), metadata: Metadata.new(change: Types::Change::UPDATED))
        resources[6] = Resource.new(uri: 'http://example.org/', modified_time: Time.utc(1999, 9, 1), metadata: Metadata.new(change: Types::Change::DELETED))
        resources[7] = Resource.new(uri: 'http://example.org/', modified_time: Time.utc(2000, 9, 1), metadata: Metadata.new(change: Types::Change::DELETED))
        list = new_instance(resources: resources)
        changes = list.changes(of_type: Types::Change::UPDATED, in_range: Time.utc(1999, 4, 1)..Time.utc(2000, 4, 1))
        expect(changes.to_a).to eq([resources[3], resources[4]])
      end
    end

  end
end
