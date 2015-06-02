require 'ruby-enum'

module Resync
  module Types
    # The type of change indicated by a reference in a {ChangeList}, {ChangeDump}, etc.
    # Values: +CREATED+, +UPDATED+, +DELETED+
    class Change
      include Ruby::Enum

      define :CREATED, 'created'
      define :UPDATED, 'updated'
      define :DELETED, 'deleted'
    end
  end
end
