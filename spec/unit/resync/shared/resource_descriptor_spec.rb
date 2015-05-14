require 'spec_helper'

module Resync
  describe ResourceDescriptor do
    describe 'hash_of_hashcodes' do
      it 'extracts a hash' do
        hash_str = 'md5:1e0d5cb8ef6ba40c99b14c0237be735e'
        hashes = ResourceDescriptor.hash_of_hashcodes(hash_str)
        expect(hashes['md5']).to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
      end

      it 'extracts multiple hashes separated by a space' do
        hash_str = 'md5:1e0d5cb8ef6ba40c99b14c0237be735e sha-256:854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784'
        hashes = ResourceDescriptor.hash_of_hashcodes(hash_str)
        expect(hashes['md5']).to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
        expect(hashes['sha-256']).to eq('854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784')
      end

      it 'extracts multiple hashes separated by arbitrary whitespace' do
        hash_str = 'md5:1e0d5cb8ef6ba40c99b14c0237be735e
                    sha-256:854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784'
        hashes = ResourceDescriptor.hash_of_hashcodes(hash_str)
        expect(hashes['md5']).to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
        expect(hashes['sha-256']).to eq('854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784')
      end

      it 'leaves a hash of hashes alone' do
        hashes = { 'md5' => '1e0d5cb8ef6ba40c99b14c0237be735e', 'sha-256' => '854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784' }
        expect(ResourceDescriptor.hash_of_hashcodes(hashes)).to eq(hashes)
      end
    end
  end
end
