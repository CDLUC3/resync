require_relative 'shared/sorted_list_examples'

module Resync
  describe ChangeDumpManifest do
    it_behaves_like SortedResourceList
  end
end
