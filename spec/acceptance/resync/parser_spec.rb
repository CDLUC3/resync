require 'spec_helper'

module Resync
  describe Parser do

    it 'parses example 1' do
      data = File.read('spec/data/examples/example-1.xml')
      urlset = Parser.parse(data)
      expect(urlset).to be_a(Urlset)

      urls = urlset.url
      expect(urls.size).to eq(2)

      url0 = urls[0]
      expect(url0.loc).to eq(URI('http://example.com/res1'))

      url1 = urls[1]
      expect(url1.loc).to eq(URI('http://example.com/res2'))
    end

    it 'parses resync elements in example 1'

  end
end
