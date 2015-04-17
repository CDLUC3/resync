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
    it 'uses the <urlset>/<sitemapindex> distinction to tell Resource Lists from Resource List Indices'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the "index" link URI for the Resource List Index, if present'
    it 'gets the list of all resource URIs'
    describe 'resources' do
      it 'gets the <loc> link URI for each resource'
      it 'gets the <lastmod> element for each resource, if present, and converts it to a Time'
      it 'gets the <changefreq> element for each resource, if present'
      it 'gets the metadata for each resource, if present'
      it 'gets the list of related resource link URIs, if any are present'
    end
  end

  describe 'resource list indices' do
    it 'retrieves a Resource List Index from a URI'
    it 'uses the <urlset>/<sitemapindex> distinction to tell Resource Lists from Resource List Indices'
    it 'gets the "up" link for the Capability List'
    it 'gets the list of all resource list URIs'
    describe 'resource lists' do
      it 'gets the <loc> link URI for each resource list'
      it 'gets the <lastmod> element for each resource list, if present, and converts it to a Time'
      it 'gets the metadata for each resource list, if present'
      it 'parses the "at" and "completed" metadata attributes, if present, and converts them to Times'
    end
  end

  describe 'resource dumps' do
    it 'retrieves a Resource Dump from a URI'
    it 'parses the "at" and "completed" metadata attributes, if present, and converts them to Times'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the "index" link URI for the Resource List Index, if present'
    it 'gets the list of all bitstream packages'
    describe 'bitstream packages' do
      it 'gets the <loc> link URI for each bitstream package'
      it 'gets the "contents" link URI for the resource dump manifest, if present'
      it 'gets the metadata for each bitstream package, if present'
      it 'can download and cache a bitstream package'
      it 'can extract a resource dump manifest from a ZIP bitstream package'
      it 'can extract a resource from a ZIP bitstream package based on a path in a manifest'
    end
  end

  describe 'resource dump manifests' do
    it 'retrieves a Resource Dump Manifest from a URI'
    it 'parses the "at" and "completed" metadata attributes, if present, and converts them to Times'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the list of all bitstreams'
    describe 'bitstreams' do
      it 'gets the <loc> link URI for each bitstream'
      it 'gets the <lastmod> element for each bitstream, if present, and converts it to a Time'
      it 'gets the <changefreq> element for each bitstream, if present'
      it 'gets the "path" attribute for each bitstream'
      it 'gets the list of related resource link URIs, if any are present'
    end
  end

  describe 'change lists' do
    it 'retrieves a Change List from a URI'
    it 'uses the <urlset>/<sitemapindex> distinction to tell Change Lists from Change List Indices'
    it 'parses the "from" and "until" metadata attributes, if present, and converts them to Times'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the "index" link URI for the Change List Index, if present'
    it 'gets the list of all resource URIs'
    it 'can get the set of all resource URIs (collapsing URIs with multiple changes)'
    it 'can find the most recent change for a given URI'
    describe 'resources' do
      it 'gets the <loc> link URI for each resource'
      it 'gets the <lastmod> element for each resource, and converts it to a Time'
      it 'gets the <changefreq> element for each resource, if present'
      it 'gets the metadata for each resource, if present'
      it 'gets the "change" attribute for each resource'
      it 'gets the list of related resource link URIs, if any are present'
    end
  end

  describe 'change list indices' do
    it 'retrieves a Change List Index from a URI'
    it 'uses the <urlset>/<sitemapindex> distinction to tell Change Lists from Change List Indices'
    it 'gets the "up" link for the Capability List'
    it 'gets the list of all change list URIs'
    describe 'change lists' do
      it 'gets the <loc> link URI for each change list'
      it 'gets the <lastmod> element for each change list, if present, and converts it to a Time'
      it 'gets the metadata for each change list, if present'
      it 'parses the "from" and "until" metadata attributes, if present, and converts them to Times'
    end
  end

  describe 'change dumps' do
    it 'retrieves a Change Dump from a URI'
    it 'parses the "from" and "until" metadata attributes, if present, and converts them to Times'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the "index" link URI for the Resource List Index, if present'
    it 'gets the list of all bitstream packages'
    describe 'bitstream packages' do
      it 'gets the <loc> link URI for each bitstream package'
      it 'gets the "contents" link URI for the change dump manifest, if present'
      it 'gets the metadata for each bitstream package, if present'
      it 'can download and cache a bitstream package'
      it 'can extract a change dump manifest from a ZIP bitstream package'
      it 'can extract a resource from a ZIP bitstream package based on a path in a manifest'
    end
  end

  describe 'change dump manifests' do
    it 'retrieves a Change Dump Manifest from a URI'
    it 'parses the "from" and "until" metadata attributes, if present, and converts them to Times'
    it 'gets the "up" link URI for the Capability List'
    it 'gets the list of all bitstreams'
    describe 'bitstreams' do
      it 'gets the <loc> link URI for each bitstream'
      it 'gets the <lastmod> element for each bitstream, if present, and converts it to a Time'
      it 'gets the <changefreq> element for each bitstream, if present'
      it 'gets the "change" attribute for each resource change'
      it 'gets the "path" attribute for each bitstream (deletes excluded)'
      it 'gets the list of related resource link URIs, if any are present'
    end
  end

  describe 'resource metadata' do
    it 'extracts the "at" attribute and parses it as a Time'
    it 'extracts the "capability" attribute'
    it 'extracts the "change" attribute'
    it 'extracts the "completed" attribute and parses it as a Time'
    it 'extracts the "encoding" attribute'
    it 'extracts the "from" attribute and parses it as a Time'
    it 'extracts the "hash" attribute'
    it 'extracts the "length" attribute and parses it as an integer'
    it 'extracts the "modified" attribute and parses it as a Time'
    it 'extracts the "path" attribute'
    it 'extracts the "type" attribute'
    it 'extracts the "until" attribute and parses it as a Time'
  end

  describe 'related resources' do
    it 'extracts the "encoding" attribute'
    it 'extracts the "hash" attribute'
    it 'extracts the "href" attribute and parses it as a URI'
    it 'extracts the "length" attribute and parses it as an integer'
    it 'extracts the "modified" attribute and parses it as a Time'
    it 'extracts the "path" attribute'
    it 'extracts the "pri" attribute'
    it 'extracts the "rel" attribute'
    it 'extracts the "type" attribute'
  end

  describe 'error handling' do
    it 'handles user/developer errors gracefully'
    it 'handles server errors gracefully'
  end

  describe 'xml handling' do
    it 'provides access to the underlying XML for all elements'
  end

  it 'does something clever for mirrors, alternate representations, and related resources'
end
