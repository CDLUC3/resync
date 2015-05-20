module Resync
  # Enumerated types for controlled vocabularies.
  module Types
    Dir.glob(File.expand_path('../types/*.rb', __FILE__), &method(:require))
  end
end
