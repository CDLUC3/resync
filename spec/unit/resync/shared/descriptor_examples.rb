module Resync
  RSpec.shared_examples Descriptor do

    # TODO: Find a better way to express this
    def new_instance(**args)
      required_args = (defined? required_arguments) ? required_arguments : {}
      args = required_args.merge(args)
      described_class.new(**args)
    end

    describe 'modified_time' do
      it 'accepts a modified timestamp' do
        modified_time = Time.utc(1997, 7, 16, 19, 20, 30.45)
        descriptor = new_instance(modified_time: modified_time)
        expect(descriptor.modified_time).to be_time(modified_time)
      end

      it 'defaults to nil if no modified timestamp is specified' do
        descriptor = new_instance
        expect(descriptor.modified_time).to be_nil
      end

      it 'fails if the modified timestamp is not a time' do
        expect { new_instance(modified_time: '12:45 pm') }.to raise_error(ArgumentError)
      end
    end

    describe 'length' do
      it 'accepts a length' do
        length = 12_345
        descriptor = new_instance(length: length)
        expect(descriptor.length).to eq(length)
      end

      it 'defaults to nil if no length is specified' do
        descriptor = new_instance
        expect(descriptor.length).to be_nil
      end

      it 'fails if length is not a non-negative integer' do
        expect { new_instance(length: -12_345) }.to raise_error(ArgumentError)
        expect { new_instance(length: 123.45) }.to raise_error(ArgumentError)
        expect { new_instance(length: 'I am not a number') }.to raise_error(ArgumentError)
      end
    end

    describe 'mime_type' do
      it 'accepts a standard MIME type' do
        mt = MIME::Types['text/plain'].first
        descriptor = new_instance(mime_type: mt)
        expect(descriptor.mime_type).to eq(mt)
      end

      it 'accepts a non-standard MIME type' do
        mt = MIME::Type.new('elvis/presley')
        descriptor = new_instance(mime_type: mt)
        expect(descriptor.mime_type).to eq(mt)
      end

      it 'accepts a MIME type as a string' do
        mt_string = 'elvis/presley'
        descriptor = new_instance(mime_type: mt_string)
        expect(descriptor.mime_type).to eq(MIME::Type.new(mt_string))
      end

      it 'defaults to nil if no MIME type is specified' do
        descriptor = new_instance
        expect(descriptor.length).to be_nil
      end

      it 'fails if mime_type isn\'t a MIME type' do
        mt_string = 'I am not a mime type'
        expect { new_instance(mime_type: mt_string) }.to raise_error(MIME::Type::InvalidContentType)
      end
    end

    describe 'encoding' do
      it 'accepts an encoding' do
        encoding = 'utf-8'
        descriptor = new_instance(encoding: encoding)
        expect(descriptor.encoding).to eq(encoding)
      end

      it 'defaults to nil if no encoding specified' do
        descriptor = new_instance
        expect(descriptor.encoding).to be_nil
      end
    end

    describe 'hash' do
      it 'accepts a hash of hashes' do
        hashes = {
          'md5' => '1e0d5cb8ef6ba40c99b14c0237be735e',
          'sha-256' => '854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784'
        }
        descriptor = new_instance(hashes: hashes)
        expect(descriptor.hashes).to eq(hashes)
        expect(descriptor.hash('md5')). to eq('1e0d5cb8ef6ba40c99b14c0237be735e')
        expect(descriptor.hash('sha-256')). to eq('854f61290e2e197a11bc91063afce22e43f8ccc655237050ace766adc68dc784')
      end

      it 'defaults to an empty hash if no hash specified' do
        descriptor = new_instance
        expect(descriptor.hashes).to eq({})
      end
    end

    describe 'path' do
      it 'accepts a path' do
        path = '/resources/res2'
        descriptor = new_instance(path: path)
        expect(descriptor.path).to eq(path)
      end

      it 'defaults to nil if no path specified' do
        descriptor = new_instance
        expect(descriptor.path).to be_nil
      end
    end

  end
end
