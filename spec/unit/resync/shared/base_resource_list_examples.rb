require 'spec_helper'

module Resync
  RSpec.shared_examples BaseResourceList do

    # ------------------------------------------------------
    # "Virtual" fixture methods

    def resource_list
      if defined? resource_list_override
        resource_list_override
      else
        [Resource.new(uri: 'http://example.org/'), Resource.new(uri: 'http://example.com/')]
      end
    end

    def new_instance(**args)
      if defined? new_instance_override
        new_instance_override(**args)
      else
        described_class.new(**args)
      end
    end

    # ------------------------------------------------------
    # Tests

    describe '#new' do
      describe 'resources' do
        it 'accepts a list of resources' do
          resources = resource_list
          list = new_instance(resources: resources)
          expect(list.resources).to eq(resources)
        end

        it 'defaults to an empty list if no resources are specified' do
          list = new_instance
          expect(list.resources).to eq([])
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
  end
end
