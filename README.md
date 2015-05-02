# resync

A Ruby gem for working with the [ResourceSync](http://www.openarchives.org/rs/1.0/resourcesync) web synchronization framework.

## Limitations

### Value restrictions not enforced

The [ResourceSync schema](http://www.openarchives.org/rs/0.9.1/resourcesync.xsd) defines restrictions on the values of several attributes:

- Path values must start with a slash, must not end with a slash
- MIME content types must conform with [RFC 2045](http://tools.ietf.org/html/rfc2045) and [RFC 2046](http://tools.ietf.org/html/rfc2046)
- Priorities must be positive and < 1,000,000
- Link relation types must conform with [RFC 5988](http://tools.ietf.org/html/rfc5988)

The [Sitemap](http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd) and [Sitemap index](http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd) schemas also define some restrictions:

- URIs have a minimum length of 12 and a max of 2048 characters.
- Priorities must be in the range 0.0-1.0 (inclusive)

None of these are currently enforced by `resync`, although it wouldn't be too hard to implement.

### `Ln`, `Md`, and `hash`

ResourceSync specifies an optional `hash` attribute on the `<rs:ln/>` and `<rs:md/>` tags, which in both cases provides a string hash of the referenced resource. When mapping these tags to Ruby objects, though, this conflicts with the built-in Ruby [hash](http://ruby-doc.org/core-2.2.1/Object.html#method-i-hash) method, meant to provide a numeric hash of the object itself, so it can be used as a hash key.

It would of course be possible to rename the `hash` attribute to something like `resource_hash` to avoid this conflict, but there would always be the risk of accidentally using the numeric object hash when what you really wanted was the resource hash, and getting the resource hash seems likely to be a much more common use case than using an [Ln](lib/resync/ln.rb) or an [Md](lib/resync/md.rb) as a hash key. If you try to do so, therefore, you'll get `TypeError: no implicit conversion of String into Integer`.

