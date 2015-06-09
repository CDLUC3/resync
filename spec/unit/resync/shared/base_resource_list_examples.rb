require 'spec_helper'
require_relative 'augmented_examples'

module Resync
  RSpec.shared_examples BaseResourceList do

    # ------------------------------------------------------
    # "Virtual" fixture methods

    # TODO: Find a better way to express this
    def resource_list
      (defined? valid_resources) ? valid_resources : [
        Resource.new(uri: 'http://example.com/res1'),
        Resource.new(uri: 'http://example.com/res2'),
        Resource.new(uri: 'http://example.com/res3'),
        Resource.new(uri: 'http://example.com/res4')
      ]
    end

    # TODO: Find a better way to express this
    def new_instance(**args)
      required_args = (defined? required_arguments) ? required_arguments : {}
      args = required_args.merge(args)
      described_class.new(**args)
    end

    # ------------------------------------------------------
    # Tests

    describe '#new' do
      describe 'resources' do
        it 'accepts a list of resources' do
          resources = resource_list
          list = new_instance(resources: resources)
          expect(list.resources.to_a).to eq(resources)
        end

        it 'is lazy' do
          resources = resource_list
          list = new_instance(resources: resources)

          half = resources.size / 2
          (0...resources.size).each do |i|
            if i < half
              expect(resources[i]).to receive(:priority).and_return(i)
            else
              expect(resources[i]).not_to receive(:priority)
            end
          end

          count = 0
          list.resources.take(half).each do |r|
            expect(r.priority).to eq(count)
            count += 1
          end
        end

        it 'defaults to an empty list if no resources are specified' do
          list = new_instance
          expect(list.resources.to_a).to eq([])
        end
      end

      describe 'metadata' do
        it 'accepts metadata' do
          metadata = Metadata.new(capability: described_class::CAPABILITY)
          list = new_instance(metadata: metadata)
          expect(list.metadata).to eq(metadata)
        end

        it 'defaults (otherwise empty) metadata with capability CAPABILITY if no metadata specified' do
          list = new_instance
          metadata = list.metadata
          expect(metadata.capability).to eq(described_class::CAPABILITY)
        end

        it 'fails if metadata does not have capability CAPABILITY' do
          expect { new_instance(metadata: Metadata.new) }.to raise_error(ArgumentError)
          expect { new_instance(metadata: Metadata.new(capability: "not_#{described_class::CAPABILITY}")) }.to raise_error(ArgumentError)
        end
      end
    end

    describe '#resources_for' do
      it 'can retrieve a list of resources by capability' do
        unless defined? valid_resources
          resources = [
            Resource.new(uri: 'http://example.com/dataset1/resourcedump1.xml', metadata: Metadata.new(capability: 'resourcedump')),
            Resource.new(uri: 'http://example.com/dataset1/changelist1.xml', metadata: Metadata.new(capability: 'changelist')),
            Resource.new(uri: 'http://example.com/dataset1/resourcedump2.xml', metadata: Metadata.new(capability: 'resourcedump')),
            Resource.new(uri: 'http://example.com/dataset1/changelist2.xml', metadata: Metadata.new(capability: 'changelist'))
          ]
          list = new_instance(resources: resources)
          expect(list.resources_for(capability: 'resourcedump').to_a).to eq([resources[0], resources[2]])
          expect(list.resources_for(capability: 'changelist').to_a).to eq([resources[1], resources[3]])
          expect(list.resources_for(capability: 'changedump').to_a).to eq([])
        end
      end
    end

    describe '#resource_for' do
      it 'can retrieve the first resource for a capability' do
        unless defined? valid_resources
          resources = [
            Resource.new(uri: 'http://example.com/dataset1/resourcedump1.xml', metadata: Metadata.new(capability: 'resourcedump')),
            Resource.new(uri: 'http://example.com/dataset1/changelist1.xml', metadata: Metadata.new(capability: 'changelist')),
            Resource.new(uri: 'http://example.com/dataset1/resourcedump2.xml', metadata: Metadata.new(capability: 'resourcedump')),
            Resource.new(uri: 'http://example.com/dataset1/changelist2.xml', metadata: Metadata.new(capability: 'changelist'))
          ]
          list = new_instance(resources: resources)
          expect(list.resource_for(capability: 'resourcedump')).to eq(resources[0])
          expect(list.resource_for(capability: 'changelist')).to eq(resources[1])
          expect(list.resource_for(capability: 'changedump')).to eq(nil)
        end
      end
    end

    describe '#capability' do
      it 'extracts the capability' do
        metadata = Metadata.new(capability: described_class::CAPABILITY)
        list = new_instance(metadata: metadata)
        expect(list.capability).to eq(described_class::CAPABILITY)
      end
    end

    describe '#resources_in' do
      [:at_time, :completed_time, :from_time, :until_time, :modified_time].each do |reader|
        it "allows filtering by #{reader}" do
          before_time = Time.utc(1969, 1, 1)
          start_time = Time.utc(1970, 1, 1)
          end_time = Time.utc(1980, 1, 1)
          after_time = Time.utc(1981, 1, 1)
          times = [before_time, start_time, end_time, after_time]

          writer = "#{reader}=".to_sym
          resources = resource_list
          resources.each_with_index do |r, i|
            if writer == :modified_time=
              r.send(writer, times[i])
            else
              md = r.metadata || (r.metadata = Metadata.new)
              md.send(writer, times[i])
            end
            expect(r.send(reader)).to be_time(times[i]) # just to be sure
          end

          list = new_instance(resources: resources, metadata: Metadata.new(capability: described_class::CAPABILITY))

          range_inclusive = start_time..end_time

          filtered = list.resources_in(time_range: range_inclusive, time_attr: reader).to_a
          expect(filtered.size).to eq(2)
          expect(filtered).not_to include(resources[0])
          expect(filtered).to include(resources[1])
          expect(filtered).to include(resources[2])
          expect(filtered).not_to include(resources[3])

          range_exclusive = start_time...end_time
          filtered = list.resources_in(time_range: range_exclusive, time_attr: reader).to_a
          expect(filtered.size).to eq(1)
          expect(filtered).not_to include(resources[0])
          expect(filtered).to include(resources[1])
          expect(filtered).not_to include(resources[2])
          expect(filtered).not_to include(resources[3])
        end
      end
    end

  end
end
