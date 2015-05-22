require 'rspec/core'
require 'resync'

# List of TODO items in spec form
describe Resync do

  describe 'library' do
    describe 'change lists' do
      it 'can get the set of all resource URIs (collapsing URIs with multiple changes)'
      it 'can find the most recent change for a given URI'
    end

    it 'enforces the required/forbidden time attribute table in appendix a of the spec'
  end

end
