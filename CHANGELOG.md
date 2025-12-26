## [2.0.0]

### Breaking Changes

- Removed direct constructor - use factory constructors instead
- `CensorPattern` renamed to `LanguagePattern`
- Removed `chars` parameter
- Removed `censoredWordBuilder` - replaced with strategy-specific builders

### New Features

- Three censoring strategies: `textBuilder`, `widgetBuilder`, `overlayBuilder`
- `censoredStyle` parameter for styling censored text
- `onTap` callback for interactive reveal in overlay builder
- Widget alignment control with `PlaceholderAlignment` and `TextBaseline`

### Migration

See [MIGRATION.md](MIGRATION.md) for migration guide.

## 1.0.3

- Update README.md

## 1.0.2

- Update README.md
- Update LICENSE

## 1.0.1

- Update README.md.

## 1.0.0

- Initial release.
