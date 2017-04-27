require 'typesafe_enum'

module Resync
  module Types
    # The type of change indicated by a reference in a {ChangeList}, {ChangeDump}, etc.
    # Values: +CREATED+, +UPDATED+, +DELETED+
    class Change < TypesafeEnum::Base
      %i[CREATED UPDATED DELETED].each { |c| new c }
    end
  end
end
