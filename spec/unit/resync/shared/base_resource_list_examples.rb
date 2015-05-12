require 'spec_helper'

module Resync
  RSpec.shared_examples BaseResourceList do

    # ------------------------------------------------------
    # "Virtual" fixture methods

    # TODO: Find a better way to express this
    def resource_list
      (defined? valid_resources) ? valid_resources : [Resource.new(uri: 'http://example.org/'), Resource.new(uri: 'http://example.com/')]
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
