## 0.2.2

- Added `#changes` method to `ChangeList` and `ChangeDumpManifest`, allowing filtering by change type and modified time
- Added `#change_lists` method to `ChangeListIndex`, `ChangeDumpIndex`, and `ChangeDump`, allowing filtering by from and until times

## 0.2.1

- Fixed issue where extra whitespace in `<loc/>` tags could prevent URI parsing.

## 0.2.0

- `BaseResourceList#resources` now returns an `IndexableLazy` instead of a plain array.
- Added `BaseResourcesList#resources_in` to filter resource lists by time. 
- All `Augmented` objects now expose the complete set of time attribtues, so as to avoid having to fish around in the metadata.

## 0.1.3

- Fix issue making it difficult to extend CapabilityList

## 0.1.2

- Fix issue making it difficult to extend SortedResourceList

## 0.1.1

- Add support for [Change Dump Indices](http://www.openarchives.org/rs/1.0/resourcesync#ChangeDumpIndex)
- Add support for [Resource Dump Indices](http://www.openarchives.org/rs/1.0/resourcesync#ResourceDumpIndex)

## 0.1.0

- Initial release
