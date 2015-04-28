# resync

A Ruby gem for working with the [ResourceSync](http://www.openarchives.org/rs/1.0/resourcesync) web synchronization framework

## Limitations

resync assumes that XML namespaces are given as in the [ResourceSync](http://www.openarchives.org/rs/1.0/resourcesync) specification's [examples](spec/data/examples): elements in the Sitemap namespace are assumed to be unqualified, while elements in the ResourceSync namespace are assumed to be qualified with the prefix `rs`, as in e.g.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:rs="http://www.openarchives.org/rs/terms/">
  <rs:md capability="resourcelist"
         at="2013-01-03T09:00:00Z"/>
  <url>
    <loc>http://example.com/res1</loc>
  </url>
  <url>
    <loc>http://example.com/res2</loc>
  </url>
</urlset>
```

This is due to a limitation in the underlying [nokogiri-happymapper](https://github.com/dam5s/happymapper) library, which understands namespace prefixes [but not URIs](https://github.com/dam5s/happymapper/issues/59).
