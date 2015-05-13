require 'spec_helper'

module Resync
  describe ResourceDescriptor do
    describe 'extract_hashes' do
      it 'extracts a hash' do
        hash_str = hash_str = 'md5:1e0d5cb8ef6ba40c99b14c0237be735e'
        hashes = ResourceDescriptor.extract_hashes(hash_str)
        expect(hashes['md5']).to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
      end

      it 'extracts multiple hashes separated by a space' do
        hash_str = 'md5:1e0d5cb8ef6ba40c99b14c0237be735e sha-256:854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784'
        hashes = ResourceDescriptor.extract_hashes(hash_str)
        expect(hashes['md5']).to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
        expect(hashes['sha-256']).to eq('854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784')
      end

      it 'extracts multiple hashes separated by arbitrary whitespace' do
        hash_str = 'md5:1e0d5cb8ef6ba40c99b14c0237be735e
                    sha-256:854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784'
        hashes = ResourceDescriptor.extract_hashes(hash_str)
        expect(hashes['md5']).to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
        expect(hashes['sha-256']).to eq('854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784')
      end
    end
  end
end
