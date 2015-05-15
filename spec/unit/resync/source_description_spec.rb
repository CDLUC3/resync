require 'spec_helper'
require_relative 'shared/base_resource_list_examples'
require_relative 'shared/link_collection_examples'

module Resync
  describe SourceDescription do
    it_behaves_like BaseResourceList

    describe 'links' do
      it_behaves_like LinkCollection
    end
  end
end
