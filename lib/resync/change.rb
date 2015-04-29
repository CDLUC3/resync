require 'ruby-enum'

module Resync
  class Change
    include Ruby::Enum

    define :CREATED, 'created'
    define :UPDATED, 'updated'
    define :DELETED, 'deleted'
  end
end
