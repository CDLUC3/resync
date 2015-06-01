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
        list = new_instance(links: links)
        expect(list.links).to eq(links)
      end

      it 'defaults to an empty list if no links are specified' do
        list = new_instance
        expect(list.links).to eq([])
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
        list = new_instance(links: links)
        expect(list.links_for(rel: 'describedby')).to eq([links[0], links[2]])
        expect(list.links_for(rel: 'duplicate')).to eq([links[1], links[3]])
        expect(list.links_for(rel: 'elvis')).to eq([])
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
        list = new_instance(links: links)
        expect(list.link_for(rel: 'describedby')).to eq(links[0])
        expect(list.link_for(rel: 'duplicate')).to eq(links[1])
        expect(list.link_for(rel: 'elvis')).to eq(nil)
      end
    end

  end
end
