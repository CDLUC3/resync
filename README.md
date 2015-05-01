# resync

A Ruby gem for working with the [ResourceSync](http://www.openarchives.org/rs/1.0/resourcesync) web synchronization framework.

## Limitations

ResourceSync specifies an optional `hash` attribute on the `<rs:ln/>` and `<rs:md/>` tags, which in both cases provides a string hash of the referenced resource. When mapping these tags to Ruby objects, though, this conflicts with the built-in Ruby [hash](http://ruby-doc.org/core-2.2.1/Object.html#method-i-hash) method, meant to provide a numeric hash of the object itself, so it can be used as a hash key.

It would of course be possible to rename the `hash` attribute to something like `resource_hash` to avoid this conflict, but there would always be the risk of accidentally using the numeric object hash when what you really wanted was the resource hash, and getting the resource hash seems likely to be a much more common use case than using an [Ln](lib/resync/ln.rb) or an [Md](lib/resync/md.rb) as a hash key. If you try to do so, therefore, you'll get `TypeError: no implicit conversion of String into Integer`.

