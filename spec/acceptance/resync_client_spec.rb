require 'acceptance/acceptance_helper'

describe ResyncClient do
  describe 'discovery' do
    it 'retrieves a Source Description from a URI'
    it 'gets the "describedby" link URI for the Source Description, if present'
    describe 'capability list discovery' do
      it 'gets the list of capability lists from the Source Description'
      it 'gets the <loc> link URI for each capability list'
      it 'gets the "describedby" link URI for each capability list, if present'
    end
  end

  describe 'capability lists' do
    it 'retrieves a Capability List from a URI'
    it 'gets the "up" link URI for the Source Description'
    it 'gets the "describedby" link URI for the Capability List, if present'
    it 'gets the list of all capability URIs'
    describe 'capabilities' do
      it 'gets the <loc> link URI for each capability'
      it 'gets the "capability" attribute for each capability'
    end
  end

  describe 'resource lists' do
    it 'retrieves a Resource List from a URI'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the "index" link URI for the Resource List Index, if present'
    it 'gets the list of all resource URIs'
    describe 'resources' do
      it 'gets the <loc> link URI for each resource'
      it 'gets the "lastmod" element for each resource, if present, and converts it to a Time'
      it 'gets the "changefreq" element for each resource, if present'
      it 'gets the metadata for each resource, if present'
      it 'gets the list of related resource link URIs, if any are present'
    end
  end

  describe 'resource list indices'

  describe 'resource metadata'

  describe 'related resources'

  describe 'error handling' do
    it 'handles user/developer errors gracefully'
    it 'handles server errors gracefully'
  end
end
