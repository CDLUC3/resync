require 'ruby-enum'

module Resync
  class Change
    include Ruby::Enum

    define :created, 'created'
    define :updated, 'updated'
    define :deleted, 'deleted'
  end
end
