require 'xml/mapping'
require 'resync/resource'

module Resync
  # Base module of +<sitemapindex>+ elements, such as {ChangeDumpIndex},
  # {ChangeListIndex}, {ResourceDumpIndex}, and {ResourceListIndex}.
  module SitemapIndex
    include ::XML::Mapping

    def self.included(base)
      base.extend(ClassMethods)

      base.use_mapping :sitemapindex
      base.root_element_name 'sitemapindex'
      base.array_node :resources, 'sitemap', class: Resource, default_value: [], sub_mapping: :_default
    end

    # Ensures that an index is always written as a +<sitemapindex>+.
    # Overrides +::XML::Mapping.save_to_xml+.
    def save_to_xml(options = { mapping: :_default })
      options = options.merge(mapping: :sitemapindex)
      super(options)
    end

    # Ensures that an index is always read as a +<sitemapindex>+.
    # Overrides +::XML::Mapping::ClassMethods.load_from_xml+.
    module ClassMethods
      def load_from_xml(xml, options = { mapping: :_default })
        options = options.merge(mapping: :sitemapindex)
        super(xml, options)
      end
    end
  end
end
