require 'ruby-enum'

module Resync
  module Types
    class Change
      include Ruby::Enum

      define :CREATED, 'created'
      define :UPDATED, 'updated'
      define :DELETED, 'deleted'
    end
  end
end
