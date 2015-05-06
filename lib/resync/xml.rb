
module Resync
  module XML
    Dir.glob(File.expand_path('../xml/*.rb', __FILE__), &method(:require))
  end
end
