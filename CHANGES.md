## 0.4.4 (28 April 2016)

- Update to XML::MappingExtensions 0.3.5

## 0.4.3 (25 April 2016)

- Replace all `require_relative` with absolute `require` to avoid symlink issues

## 0.4.2 (27 Jan 2016)

- Make gemspec smart enough to handle SSH checkouts
- Update to [typesafe_enum](https://github.com/dmolesUC3/typesafe_enum) 0.1.5
- Update to [xml-mapping_extensions](https://github.com/dmolesUC3/xml-mapping_extensions) 0.3.4

## 0.4.1 (19 Nov 2015)

- Update to [typesafe_enum](https://github.com/dmolesUC3/typesafe_enum) 0.1.2

## 0.4.0 (19 Nov 2015)

- Convert `Change` and `ChangeFrequency` from [ruby-enum](https://github.com/dblock/ruby-enum/) to
  [typesafe_enum](https://github.com/dmolesUC3/typesafe_enum)

## 0.3.4 (14 Oct 2015)

- Fix issue where `Dir.glob` could cause files to be required in an unpredictable order (h/t [nabeta](https://github.com/CDLUC3/resync/pull/1))

## 0.3.3 (13 Oct 2015)

- Fix links in README

## 0.3.2 (8 Oct 2015)

- Move GitHub project to [CDLUC3](https://github.com/CDLUC3/)

## 0.3.1 (11 Sep 2015)

- Use [xml-mapping_extensions](https://github.com/dmolesUC3/xml-mapping_extensions) for some XML mapping infrastructure

## 0.3.0 (19 Jun 2015)

- Return simple arrays for resources, instead of fancy lazy enumerables

## 0.2.2 (10 Jun 2015)

- Added `#changes` method to `ChangeList` and `ChangeDumpManifest`, allowing filtering by change type and modified time
- Added `#change_lists` method to `ChangeListIndex`, `ChangeDumpIndex`, and `ChangeDump`, allowing filtering by from and until times

## 0.2.1 (9 Jun 2015)

- Fixed issue where extra whitespace in `<loc/>` tags could prevent URI parsing.

## 0.2.0 (5 Jun 2015)

- `BaseResourceList#resources` now returns an `IndexableLazy` instead of a plain array.
- Added `BaseResourcesList#resources_in` to filter resource lists by time. 
- All `Augmented` objects now expose the complete set of time attribtues, so as to avoid having to fish around in the metadata.

## 0.1.3 (5 Jun 2015)

- Fix issue making it difficult to extend CapabilityList

## 0.1.2 (4 Jun 2015)

- Fix issue making it difficult to extend SortedResourceList

## 0.1.1 (3 Jun 2015)

- Add support for [Change Dump Indices](http://www.openarchives.org/rs/1.0/resourcesync#ChangeDumpIndex)
- Add support for [Resource Dump Indices](http://www.openarchives.org/rs/1.0/resourcesync#ResourceDumpIndex)

## 0.1.0 (3 Jun 2015)

- Initial release
