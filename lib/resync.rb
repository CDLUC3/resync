module Resync
  Dir.glob(File.expand_path('../resync/*.rb', __FILE__), &method(:require))
end
