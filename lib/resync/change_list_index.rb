require_relative 'shared/sorted_resource_list'
require_relative 'shared/sitemap_index'

module Resync
  # A change list index. See section 12.2,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeListIndex Change List Index}",
  # in the ResourceSync specification.
  class ChangeListIndex < SortedResourceList
    include ::XML::Mapping
    include SitemapIndex

    # The capability provided by this type.
    CAPABILITY = 'changelist'

    # use_mapping :sitemapindex
    # root_element_name 'sitemapindex'
    # array_node :resources, 'sitemap', class: Resource, default_value: [], sub_mapping: :_default
    #
    # # Ensures that an index is always written as a +<sitemapindex>+.
    # # Overrides +::XML::Mapping.save_to_xml+.
    # def save_to_xml(options = { mapping: :_default })
    #   options = options.merge(mapping: :sitemapindex)
    #   super(options)
    # end
  end
end
