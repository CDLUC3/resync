require 'rspec/core'
require 'resync'

# List of TODO items in spec form
describe Resync do

  describe 'this spec' do
    it 'separates library and client functionality'
  end

  describe 'discovery' do
    it 'retrieves a Source Description from a URI'
    it 'gets the "describedby" link URI for the Source Description, if present'
    describe 'capability list discovery' do
      it 'gets the list of capability lists from the Source Description'
      it 'gets the "describedby" link URI for each capability list, if present'
    end
  end

  describe 'capability lists' do
    it 'retrieves a Capability List from a URI'
    it 'gets the "up" link URI for the Source Description'
    it 'gets the "describedby" link URI for the Capability List, if present'

    describe 'capabilities' do
      it 'gets the "capability" attribute for each capability'
    end
  end

  describe 'resource lists' do
    it 'retrieves a Resource List from a URI'
    it 'uses the <urlset>/<sitemapindex> distinction to tell Resource Lists from Resource List Indices'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the "index" link URI for the Resource List Index, if present'
  end

  describe 'resource list indices' do
    it 'retrieves a Resource List Index from a URI'
    it 'uses the <urlset>/<sitemapindex> distinction to tell Resource Lists from Resource List Indices'
    it 'gets the "up" link for the Capability List'
  end

  describe 'resource dumps' do
    it 'retrieves a Resource Dump from a URI'
    it 'parses the "at" and "completed" metadata attributes, if present, and converts them to Times'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the "index" link URI for the Resource List Index, if present'

    describe 'bitstream packages' do
      it 'gets the "contents" link URI for the resource dump manifest, if present'
      it 'can download and cache a bitstream package'
      it 'can extract a resource dump manifest from a ZIP bitstream package'
      it 'can extract a resource from a ZIP bitstream package based on a path in a manifest'
    end
  end

  describe 'resource dump manifests' do
    it 'retrieves a Resource Dump Manifest from a URI'
    it 'parses the "at" and "completed" metadata attributes, if present, and converts them to Times'
    it 'gets the "up" link URI for the Capability List'
  end

  describe 'change lists' do
    it 'retrieves a Change List from a URI'
    it 'uses the <urlset>/<sitemapindex> distinction to tell Change Lists from Change List Indices'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the "index" link URI for the Change List Index, if present'
    it 'can get the set of all resource URIs (collapsing URIs with multiple changes)'
    it 'can find the most recent change for a given URI'
  end

  describe 'change list indices' do
    it 'retrieves a Change List Index from a URI'
    it 'uses the <urlset>/<sitemapindex> distinction to tell Change Lists from Change List Indices'
    it 'gets the "up" link for the Capability List'
  end

  describe 'change dumps' do
    it 'retrieves a Change Dump from a URI'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the "index" link URI for the Resource List Index, if present'
    describe 'bitstream packages' do
      it 'gets the "contents" link URI for the change dump manifest, if present'
      it 'can download and cache a bitstream package'
      it 'can extract a change dump manifest from a ZIP bitstream package'
      it 'can extract a resource from a ZIP bitstream package based on a path in a manifest'
    end
  end

  describe 'change dump manifests' do
    it 'retrieves a Change Dump Manifest from a URI'
    it 'gets the "up" link URI for the Capability List'
  end

  describe 'error handling' do
    it 'handles user/`developer errors gracefully'
    it 'handles server errors gracefully'
  end

  it 'does something clever for mirrors, alternate representations, and related resources'

  it 'enforces the required/forbidden time attribute table in appendix a of the spec'
end
