# resync

A Ruby gem for working with the [ResourceSync](http://www.openarchives.org/rs/1.0/resourcesync) web synchronization framework.

## Limitations

### Value restrictions not enforced

The [ResourceSync schema](http://www.openarchives.org/rs/0.9.1/resourcesync.xsd) defines restrictions on the values of several attributes:

- Path values must start with a slash, must not end with a slash
- Priorities must be positive and < 1,000,000
- Link relation types must conform with [RFC 5988](http://tools.ietf.org/html/rfc5988)

The [Sitemap](http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd) and [Sitemap index](http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd) schemas also define some restrictions:

- URIs have a minimum length of 12 and a max of 2048 characters.
- Priorities must be in the range 0.0-1.0 (inclusive)

None of these are currently enforced by `resync`, although the restrictions wouldn't be too hard to implement.

### Supported capabilities

- resourcelist
- changelist
- resourcedump
- resourcedump-manifest
- changedump
- changedump-manifest
