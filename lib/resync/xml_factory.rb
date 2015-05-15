require_relative 'xml'

module Resync
  module XMLFactory

    ROOT_TYPES = [
        ChangeDump,
        ChangeDumpManifest,
        ChangeList,
        ResourceDump,
        ResourceDumpManifest,
        ResourceList,
        SourceDescription
    ]

    CAPABILITY_ATTRIBUTE = "/*/[namespace-uri() = 'http://www.openarchives.org/rs/terms/' and local-name() = 'md']/@capability"

    def self.parse(xml:)
      root_element = XML.element(xml)
      capability = REXML::XPath.first(root_element, CAPABILITY_ATTRIBUTE).value
      root_type = ROOT_TYPES.find { |t| t::CAPABILITY == capability }
      root_type.load_from_xml(root_element)
    end

  end
end
