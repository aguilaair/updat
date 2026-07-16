## 1.4.1

* Fix `UpdatWindowManager` ignoring `preventClose` from `window_manager` (<https://github.com/aguilaair/updat/issues/31>)
* Add `handleWindowClose` and `onBeforeClose` to `UpdatWindowManager` for custom close handling
* Add `UpdatTranslations` for localizing default UI strings (<https://github.com/aguilaair/updat/issues/30>)
* Add `UpdatController` for programmatic update re-checks
* Update dependencies and raise minimum SDK to Dart 3.8 / Flutter 3.27

## 1.4.0

* Update dependencies

## 1.3.2

* Fix images not displaying on pub.dev
* Update dependencies

## 1.3.1

* Add support for `updatWindowManager` to mobile platforms and web. (Just bypasses the updat system)
* Update dependencies

## 1.3.0

* Support unzipping (<https://github.com/aguilaair/updat/issues/5>)
* Allow custom headers to be provided for GET methods (<https://github.com/aguilaair/updat/issues/4>)
* Fix closeOnInstall (<https://github.com/aguilaair/updat/issues/9>)
* Fix launchOnExit (<https://github.com/aguilaair/updat/issues/8>)

## 1.2.0+1

* Change to MPL-2.0 license :D
* Dependency updates

## 1.2.0

* New  `UpdateWindowManager` that simplifies usage
* Better MacOS support
* Add new themes (silent downloads, flat) 

## 1.1.0

* Add `callback` function to `Updat`

## 1.0.0+2

* Fixes for pub.dev

## 1.0.0

* Initial release with all features working.
