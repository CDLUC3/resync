# resync

A Ruby gem for working with the [ResourceSync](http://www.openarchives.org/rs/1.0/resourcesync) web synchronization framework.

## See also

[resync-client](https://github.com/dmolesUC3/resync-client), a Ruby client library for ResourceSync.

## Limitations

### Time attribute requirements

The required/forbidden time attributes defined in Appendix A,
"[Time Attribute Requirements](http://www.openarchives.org/rs/1.0/resourcesync#TimeAttributeReqs)",
of the ResourceSync specification are not enforced; it's possible to
create, e.g., a `ResourceList` with a `from_time` on its metadata, or a `ChangeList` with members whose metadata does not declare a `modified_time`, even though both scenarios are forbidden by the specification.

### Other value restrictions

The [ResourceSync schema](http://www.openarchives.org/rs/0.9.1/resourcesync.xsd) defines restrictions on the values of several attributes:

- Path values must start with a slash, must not end with a slash
- Priorities must be positive and < 1,000,000
- Link relation types must conform with [RFC 5988](http://tools.ietf.org/html/rfc5988)

The [Sitemap](http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd) and [Sitemap index](http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd) schemas also define some restrictions:

- URIs have a minimum length of 12 and a max of 2048 characters.
- Priorities must be in the range 0.0-1.0 (inclusive)

None of these restrictions are currently enforced by `resync`, although they wouldn't be too hard to implement.

### Element order

When reading a ResourceSync document from XML and writing it back out, `<rs:ln>` elements will always appear before `<rs:md>` elements, regardless of their order in the original source.

### Namespace weirdness

The [XML::Mapping](https://github.com/multi-io/xml-mapping) library doesn't support namespaces, so namespace handling in `resync` is a bit hacky. In particular, you may see strange behavior when using `<rs:ln>`, `<rs:md>`, `<url>`, or `<sitemap>` tags outside the context of a `<urlset>`/`<sitemapindex>`.
