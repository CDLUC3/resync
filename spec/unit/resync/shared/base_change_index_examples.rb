require_relative 'sorted_list_examples'

module Resync
  RSpec.shared_examples BaseChangeIndex do
    it_behaves_like SortedResourceList

    describe '#change_lists' do
      it 'filters by time range' do
        resources = []
        resources[0] = Resource.new(uri: 'http://example.org/changes-0', metadata: Metadata.new(until_time: Time.utc(2000)))
        resources[1] = Resource.new(uri: 'http://example.org/changes-1', metadata: Metadata.new(from_time: Time.utc(2000), until_time: Time.utc(2001)))
        resources[2] = Resource.new(uri: 'http://example.org/changes-2', metadata: Metadata.new(from_time: Time.utc(2001), until_time: Time.utc(2002)))
        resources[3] = Resource.new(uri: 'http://example.org/changes-3', metadata: Metadata.new(from_time: Time.utc(2002)))
        index = ChangeListIndex.new(resources: resources)

        changes = index.change_lists(in_range: Time.utc(1999)..Time.utc(2000, 7, 1)).to_a
        expect(changes.size).to eq(2)
        expect(changes).to include(resources[0])
        expect(changes).to include(resources[1])

        changes = index.change_lists(in_range: Time.utc(2000, 7, 1)..Time.utc(2001, 7, 1)).to_a
        expect(changes.size).to eq(2)
        expect(changes).to include(resources[1])
        expect(changes).to include(resources[2])

        changes = index.change_lists(in_range: Time.utc(2001, 7, 1)..Time.utc(2003, 7, 1)).to_a
        expect(changes.size).to eq(2)
        expect(changes).to include(resources[2])
        expect(changes).to include(resources[3])
      end

      it 'ignores resources with neither from nor until time' do
        resources = []
        resources[0] = Resource.new(uri: 'http://example.org/changes-0', metadata: Metadata.new(until_time: Time.utc(2000)))
        resources[1] = Resource.new(uri: 'http://example.org/changes-1', metadata: Metadata.new(from_time: Time.utc(2000), until_time: Time.utc(2001)))
        resources[2] = Resource.new(uri: 'http://example.org/changes-2', metadata: Metadata.new(from_time: Time.utc(2001), until_time: Time.utc(2002)))
        resources[3] = Resource.new(uri: 'http://example.org/changes-3', metadata: Metadata.new(from_time: Time.utc(2002)))
        resources[4] = Resource.new(uri: 'http://example.org/changes-4')
        resources[5] = Resource.new(uri: 'http://example.org/changes-5')
        index = ChangeListIndex.new(resources: resources)
        changes = index.change_lists(in_range: Time.utc(2000, 7, 1)..Time.utc(2001, 7, 1)).to_a
        expect(changes.size).to eq(2)
        expect(changes).to include(resources[1])
        expect(changes).to include(resources[2])
      end

      it 'includes resources with neither from nor until time when in non-strict mode' do
        resources = []
        resources[0] = Resource.new(uri: 'http://example.org/changes-0', metadata: Metadata.new(until_time: Time.utc(2000)))
        resources[1] = Resource.new(uri: 'http://example.org/changes-1', metadata: Metadata.new(from_time: Time.utc(2000), until_time: Time.utc(2001)))
        resources[2] = Resource.new(uri: 'http://example.org/changes-2', metadata: Metadata.new(from_time: Time.utc(2001), until_time: Time.utc(2002)))
        resources[3] = Resource.new(uri: 'http://example.org/changes-3', metadata: Metadata.new(from_time: Time.utc(2002)))
        resources[4] = Resource.new(uri: 'http://example.org/changes-4')
        resources[5] = Resource.new(uri: 'http://example.org/changes-5')
        index = ChangeListIndex.new(resources: resources)
        changes = index.change_lists(in_range: Time.utc(2000, 7, 1)..Time.utc(2001, 7, 1), strict: false).to_a
        expect(changes.size).to eq(4)
        expect(changes).to include(resources[1])
        expect(changes).to include(resources[2])
        expect(changes).to include(resources[4])
        expect(changes).to include(resources[5])
      end
    end

  end
end
