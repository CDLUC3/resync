# resync

A Ruby gem for working with the [ResourceSync](http://www.openarchives.org/rs/1.0/resourcesync) web synchronization framework.

It consists of the following:

  - Classes corresponding to the major document types defined in the ResourceSync specification, such as [Resource Lists](http://www.openarchives.org/rs/1.0/resourcesync#ResourceList), [Change Lists](http://www.openarchives.org/rs/1.0/resourcesync#ChangeList), [Source Descriptions](http://www.openarchives.org/rs/1.0/resourcesync#SourceDesc) and so on. Each of these classes has a `load_from_xml` method that can parse the corresponding XML document (as an `REXML::Element`), and a `save_to_xml` method that can serialize an instance of that class to XML (as an `REXML::Element`).
  - Classes for the [major sub-structures](http://www.openarchives.org/rs/1.0/resourcesync#DocumentFormats) of those documents, such as the `<url>` and `<sitemap>` tags (subsumed under the [Resource](lib/resync/resource.rb) class) defined by the Sitemap specification, as well as the ResourceSync-specific `<rs:ln>` and `<rs:md>` tags (the [Link](lib/resync/link.rb) and [Metadata](lib/resync/metadata.rb) classes, respectively).
  - An [XMLParser](lib/resync/xml_parser.rb) class that can take a ResourceSync-augmented Sitemap document (in the form of an `REXML::Element`, an `REXML::Document`, a string, an `IO`, or something sufficiently `IO`-like that `REXML::Document` can parse it) and produce an instance of the appropriate class based on the `capability` attribute in the root element's metadata.

## Status

This is a work in progress. We welcome bug reports and feature requests (particularly on the document creation side, which our use cases haven't really explored).

## Usage

### Parsing a ResourceSync document

```ruby
require 'resync'

data = File.read('my-capability-list.xml')
capability_list = Resync::XMLParser.parse(data)
```

### Writing a ResourceSync document

```ruby
require 'resync'

change_list = Resync::ChangeList.new(
  links: [ Resync::Link.new(rel='up', href='http://example.com/my-dataset/my-capability-list.xml') ],
  metadata: Resync::Metadata.new(
    capability = 'changelist',
    from_time = Time.utc(2013, 1, 3)
  )
  resources: [
    # ... generate list of changes here ...
  ]
)
xml = change_list.save_to_xml
formatter = REXML::Formatters::Pretty.new
formatter.write(xml, $stdout)
```

## See also

[resync-client](https://github.com/dmolesUC3/resync-client), a Ruby client library for ResourceSync.

## Limitations

### Structural inconvenience and unnecessary repetition

There are certain well-specified relationships between elements: most document types should always have a link with an `up` relationship, many resources should have metadata with a defined `capability` attribute, and so on. In some cases there are convenience getters for these attributes on the 'parent' object (e.g. you can ask for the `capability` directly without violating the law of Demeter), but there generally aren't corresponding convenience setters, or convenience initializer parameters.

Document types (`ChangeList`, `ResourceList`, etc.) will create a `Metadata` with the appropriate capability for themselves if none is specified, but if they're initialized with one that doesn't declare a capability, they'll raise an exception rather than fill it in (just as they'll raise an exception if the wrong capability is specified).

### Logical relationships between elements

A `ChangeList` should contain only resources with `Metadata` declaring a `change` type. The resources in a `ResourceDumpManifest` should each declare a `path` indicating their locations in the ZIP file. `resync` doesn't currently do anything to enforce, validate, or assist in compliance with these and similar restrictions.

(An exception: document types will complain if initialized with `Metadata` having the wrong capability.)

### Time attribute requirements

The required/forbidden time attributes defined in Appendix A,
"[Time Attribute Requirements](http://www.openarchives.org/rs/1.0/resourcesync#TimeAttributeReqs)",
of the ResourceSync specification are not enforced; it's possible to
create, e.g., a `ResourceList` with a `from_time` on its metadata, or a `ChangeList` with members whose metadata does not declare a `modified_time`, even though both scenarios are forbidden by the specification.

### Value restrictions from XML schemata

The [ResourceSync schema](http://www.openarchives.org/rs/0.9.1/resourcesync.xsd) defines restrictions on the values of several attributes:

- Path values must start with a slash, must not end with a slash
- Priorities must be positive and < 1,000,000
- Link relation types must conform with [RFC 5988](http://tools.ietf.org/html/rfc5988)

The [Sitemap](http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd) and [Sitemap index](http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd) schemas also define some restrictions:

- URIs have a minimum length of 12 and a max of 2048 characters.
- Priorities must be in the range 0.0-1.0 (inclusive)

None of these restrictions are currently enforced by `resync`.

### Element order

When reading a ResourceSync document from XML and writing it back out, `<rs:ln>` elements will always appear before `<rs:md>` elements, regardless of their order in the original source.

### Namespace weirdness

The [XML::Mapping](https://github.com/multi-io/xml-mapping) library `resync` uses doesn't support namespaces, so namespace handling in `resync` is a bit hacky. In particular, you may see strange behavior when using `<rs:ln>`, `<rs:md>`, `<url>`, or `<sitemap>` tags outside the context of a `<urlset>`/`<sitemapindex>`.
