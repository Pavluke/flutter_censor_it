<p align="center">
  <img src="https://github.com/Pavluke/flutter_censor_it/blob/main/images/banner.gif?raw=true" alt="Banner" />
</p>

[![Pub](https://img.shields.io/pub/v/flutter_censor_it.svg)](https://pub.dartlang.org/packages/flutter_censor_it)

**En** | [Ru](README_RU.md)

Flutter widget for censoring text based on predefined patterns with customizable
strategies. Built on top of [censor_it](https://pub.dev/packages/censor_it)
package.

## Migration Guide

Upgrading from v1.x? See the detailed [Migration Guide](MIGRATION.md) for
step-by-step instructions.

## Introduction

When it comes to censoring profanity in your Flutter application, you might need
to handle multiple languages and customize the visual representation of censored
content. `CensorItWidget` provides an easy-to-use solution with three distinct
censoring strategies.

## Supported languages

- 🇺🇸 English (EN)
- 🇫🇮 Finnish (FI)
- 🇫🇷 French (FR)
- 🇩🇪 German (DE)
- 🇮🇹 Italian (IT)
- 🇰🇿 Kazakh (KZ)
- 🇱🇻 Latvian (LV)
- 🇱🇹 Lithuanian (LT)
- 🇵🇹 Portuguese (PT)
- 🇵🇱 Polish (PL)
- 🇷🇺 Russian (RU)
- 🇪🇸 Spanish (ES)
- 🇸🇪 Swedish (SE)
- 🇺🇦 Ukrainian (UA)

## Getting started

Add flutter_censor_it to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_censor_it: ^2.0.0
```

Or using the command:

```bash
flutter pub add flutter_censor_it
```

Import the package in your Dart file:

```dart
import 'package:flutter_censor_it/flutter_censor_it.dart';
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_censor_it/flutter_censor_it.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CensorItWidget.textBuilder(
            'Holy shit, this fucking works!',
            builder: (context, word) => '[censored]',
            pattern: LanguagePattern.english,
            censoredStyle: TextStyle(
              color: Colors.red,
              fontWeight: .bold,
            ),
          ),
        ),
      ),
    );
  }
}
```

## Factory Constructors (v2.0.0+)

CensorItWidget v2.0.0 introduces three factory constructors for different
censoring strategies:

### 1. CensorItWidget.textBuilder() - Text Replacement

Replaces profanity with custom text.

```dart
CensorItWidget.textBuilder(
  'Fuck this shit!',
  builder: (context, word) => '[censored]',
  pattern: LanguagePattern.english,
  style: TextStyle(color: Colors.black),
  censoredStyle: TextStyle(color: Colors.red, fontWeight: .bold),
)
```

**Output:** "~~Fuck~~ [censored] this ~~shit~~ [censored]!" (censored words in
red)

**Use case:** Simple text-based censoring with custom styling.

### 2. CensorItWidget.widgetBuilder() - Widget Replacement

Replaces profanity with Flutter widgets.

```dart
CensorItWidget.widgetBuilder(
  'Fuck this shit!',
  builder: (context, word) => Icon(Icons.block, size: 16, color: Colors.red),
  pattern: LanguagePattern.english,
  alignment: .middle,
)
```

**Output:** "🚫 this 🚫!" (profanity replaced with icons)

**Use case:** Visual censoring with icons, images, or custom widgets.

### 3. CensorItWidget.overlayBuilder() - Visual Effects

Applies visual effects over profanity while keeping original text in layout.

```dart
CensorItWidget.overlayBuilder(
  'Fuck this shit!',
  builder: (context, word, revealed) => Container(
    decoration: BoxDecoration(
      color: revealed ? Colors.transparent : Colors.black.withOpacity(0.8),
      borderRadius: .circular(4),
    ),
  ),
  pattern: LanguagePattern.english,
  onTap: (revealed) => !revealed, // Tap to reveal/hide
)
```

**Output:** Profanity covered with dark overlay, tap to reveal

**Use case:** Interactive censoring with blur effects, overlays, or
tap-to-reveal.

## Advanced Usage

### Dynamic Text Replacement

```dart
CensorItWidget.textBuilder(
  'Fuck this shit!',
  builder: (context, word) {
    // Different replacements based on word length
    if (word.length > 4) return '[CENSORED]';
    return '***';
  },
  pattern: LanguagePattern.english,
)
```

### Custom Widget Censoring

```dart
CensorItWidget.widgetBuilder(
  'Fuck this!',
  builder: (context, word) => Container(
    padding: .symmetric(horizontal: 4, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: .circular(4),
    ),
    child: Text('***', style: TextStyle(color: Colors.white, fontSize: 10)),
  ),
  pattern: LanguagePattern.english,
  alignment: .middle,
  baseline: .alphabetic,
)
```

### Blur Effect with Overlay

```dart
import 'dart:ui';

CensorItWidget.overlayBuilder(
  'Fuck this!',
  builder: (context, word, revealed) => ClipRRect(
    child: BackdropFilter(
      filter: .blur(
        sigmaX: revealed ? 0 : 5,
        sigmaY: revealed ? 0 : 5,
      ),
      child: Container(color: Colors.transparent),
    ),
  ),
  pattern: LanguagePattern.english,
  onTap: (revealed) => !revealed,
)
```

**Use case:** Elegant blur effect that can be toggled.

### Animated Reveal

```dart
CensorItWidget.overlayBuilder(
  'Fuck this!',
  builder: (context, word, revealed) => AnimatedContainer(
    duration: Duration(milliseconds: 300),
    decoration: BoxDecoration(
      gradient: revealed
          ? null
          : LinearGradient(colors: [Colors.purple, Colors.blue]),
      borderRadius: .circular(4),
    ),
  ),
  pattern: LanguagePattern.english,
  onTap: (revealed) => !revealed,
)
```

**Use case:** Smooth animated transitions for reveal/hide.

## Language Patterns

### Using Predefined Patterns

```dart
// Single language
CensorItWidget.textBuilder(
  'Fuck this!',
  builder: (context, word) => '***',
  pattern: LanguagePattern.english,
)

// All languages
CensorItWidget.textBuilder(
  'Fuck this блять!',
  builder: (context, word) => '***',
  pattern: LanguagePattern.all,
)
```

### Combining Multiple Languages

```dart
// Combine specific languages
CensorItWidget.textBuilder(
  'Fuck this puta!',
  builder: (context, word) => '***',
  pattern: CensorPattern.multi([
    LanguagePattern.english,
    LanguagePattern.spanish,
  ]),
)
```

### Locale-Based Pattern Selection

```dart
// Get pattern by locale code
final latvian = LanguagePattern.fromLocale('lv');
CensorItWidget.textBuilder(
  'pizdets',
  builder: (context, word) => '***',
  pattern: latvian,
)

// Multiple locales
final multi = LanguagePattern.fromLocales(['en', 'es']);
CensorItWidget.textBuilder(
  'fuck this puta',
  builder: (context, word) => '***',
  pattern: multi,
)
```

### Custom Patterns with RegExp

```dart
// Create custom pattern with RegExp
final customPattern = CensorPattern.fromRegExp(
  RegExp(r'badword|anotherbad', caseSensitive: false),
);

CensorItWidget.textBuilder(
  'badword here',
  builder: (context, word) => '[censored]',
  pattern: customPattern,
)
```

## Features

- **Three Censoring Strategies**: Choose from text, widget, or overlay-based
  censoring
- **Factory Constructors**: Clean API with `CensorItWidget.textBuilder()`,
  `CensorItWidget.widgetBuilder()`, etc.
- **Custom Styling**: Separate `style` and `censoredStyle` for normal and
  censored text
- **Interactive**: `onTap` callback for reveal/hide functionality in overlay
  builder
- **Widget Alignment**: Control vertical alignment with `PlaceholderAlignment`
  and `TextBaseline`
- **Profanity Detection**: Built on `censor_it` package with robust pattern
  matching
- **Multilingual Support**: 14+ languages with Unicode support
- **High Performance**: Optimized text span building for smooth rendering

## What's New in v2.0.0

### Factory Constructors

- ✅ **`CensorItWidget.textBuilder()`** - Replace with custom text
- ✅ **`CensorItWidget.widgetBuilder()`** - Replace with widgets
- ✅ **`CensorItWidget.overlayBuilder()`** - Apply visual effects

### New Parameters

- ✅ **`censoredStyle`** - Custom styling for censored text
- ✅ **`onTap`** - Interactive tap-to-reveal in overlay builder
- ✅ **`alignment`** - Widget vertical alignment control
- ✅ **`baseline`** - Baseline alignment for widgets

### Breaking Changes

- ❌ **Removed direct constructor** - Use factory constructors
- ❌ **Removed `chars` parameter** - Implement in builder function
- ❌ **Renamed `CensorPattern`** to `LanguagePattern`

See [MIGRATION.md](MIGRATION.md) for upgrade instructions.

## Changelog

The list of changes is available in the file [CHANGELOG.md](CHANGELOG.md)

## Contributions

Feel free to contribute to this project. If you find a bug or want to add a new
feature but don't know how to fix/implement it, please write in
[issues](https://github.com/pavluke/flutter_censor_it/issues). If you fixed a
bug or implemented some feature, please make
[pull request](https://github.com/pavluke/flutter_censor_it/pulls).

## License

MIT License - see [LICENSE](LICENSE) file for details
