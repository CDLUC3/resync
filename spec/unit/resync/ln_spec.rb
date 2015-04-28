require 'spec_helper'

module Resync
  describe Ln do
    it 'parses a tag' do
      ln = Ln.parse('<ln/>', single: true)
      expect(ln).to be_an(Ln)
    end

    it 'parses a namespaced tag' do
      ln = Ln.parse('<rs:ln/>', single: true)
      expect(ln).to be_an(Ln)
    end
  end
end
