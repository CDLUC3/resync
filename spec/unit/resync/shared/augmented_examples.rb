module Resync
  # TODO: Figure out if 'up' is mandatory for all resource lists, or just CapabilityList
  # TODO: Consider requiring this in base_resource_list_examples again, if 'up' is mandatory
  RSpec.shared_examples Augmented do

    # TODO: Find a better way to express this
    def new_instance(**args)
      required_args = (defined? required_arguments) ? required_arguments : {}
      args = required_args.merge(args)
      described_class.new(**args)
    end

    describe 'links' do
      it 'accepts a list of links' do
        links = [Link.new(rel: 'describedby', uri: 'http://example.org/'), Link.new(rel: 'duplicate', uri: 'http://example.com/')]
        augmented = new_instance(links: links)
        expect(augmented.links).to eq(links)
      end

      it 'defaults to an empty augmented if no links are specified' do
        augmented = new_instance
        expect(augmented.links).to eq([])
      end
    end

    describe '#links_for' do
      it 'can retrieve a list of links by rel' do
        links = [
          Link.new(rel: 'describedby', uri: 'http://example.org/desc1'),
          Link.new(rel: 'duplicate', uri: 'http://example.com/dup1'),
          Link.new(rel: 'describedby', uri: 'http://example.org/desc2'),
          Link.new(rel: 'duplicate', uri: 'http://example.com/dup2')
        ]
        augmented = new_instance(links: links)
        expect(augmented.links_for(rel: 'describedby')).to eq([links[0], links[2]])
        expect(augmented.links_for(rel: 'duplicate')).to eq([links[1], links[3]])
        expect(augmented.links_for(rel: 'elvis')).to eq([])
      end
    end

    describe '#link_for' do
      it 'can retrieve the first link for a rel' do
        links = [
          Link.new(rel: 'describedby', uri: 'http://example.org/desc1'),
          Link.new(rel: 'duplicate', uri: 'http://example.com/dup1'),
          Link.new(rel: 'describedby', uri: 'http://example.org/desc2'),
          Link.new(rel: 'duplicate', uri: 'http://example.com/dup2')
        ]
        augmented = new_instance(links: links)
        expect(augmented.link_for(rel: 'describedby')).to eq(links[0])
        expect(augmented.link_for(rel: 'duplicate')).to eq(links[1])
        expect(augmented.link_for(rel: 'elvis')).to eq(nil)
      end
    end

    describe 'additional time attributes' do
      it 'extracts the at_time, from_time, until_time, and completed_time from the metadata' do
        capability = described_class::CAPABILITY if defined?(described_class::CAPABILITY)
        md = Metadata.new(
          at_time: Time.utc(1972, 5, 18),
          from_time: Time.utc(1976, 7, 24),
          until_time: Time.utc(1983, 1, 21),
          completed_time: Time.utc(1981, 10, 4),
          capability: capability
        )
        augmented = new_instance(metadata: md)
        [:at_time, :from_time, :until_time, :completed_time].each do |t|
          puts augmented.send(t)
          expect(augmented.send(t)).to be_time(md.send(t))
        end
      end
    end

  end
end
