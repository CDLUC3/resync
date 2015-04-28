require 'spec_helper'

module Resync
  describe Parser do

    it 'parses example 1' do

      puts Parser.instance_methods

      data = File.read('spec/data/examples/example-1.xml')
      urlset = Parser.parse(data)
      expect(urlset).to be_a(Urlset)
    end

  end
end
