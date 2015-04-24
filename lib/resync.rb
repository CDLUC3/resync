module Resync
  Dir.glob(File.expand_path('../resync_client/*.rb', __FILE__), &method(:require))
end
