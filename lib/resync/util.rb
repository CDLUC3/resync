module Resync
  # Miscellaneous utilities
  module Types
    Dir.glob(File.expand_path('../util/*.rb', __FILE__), &method(:require))
  end
end
