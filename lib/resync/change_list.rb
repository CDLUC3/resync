require 'resync/shared/base_change_list'
require 'resync/xml'

module Resync
  # A change list. See section 12.1,
  # "{http://www.openarchives.org/rs/1.0/resourcesync#ChangeList Change List}",
  # in the ResourceSync specification.
  class ChangeList < BaseChangeList
    include ::XML::Mapping

    # The capability provided by this type.
    CAPABILITY = 'changelist'.freeze

  end
end
