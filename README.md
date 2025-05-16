<p align="center">
  <img src="https://github.com/Pavluke/flutter_censor_it/blob/main/images/banner.gif?raw=true" alt="Preview" />
</p>

[![Pub](https://img.shields.io/pub/v/flutter_censor_it.svg)](https://pub.dartlang.org/packages/flutter_censor_it)

Flutter widget for censoring text based on predefined patterns and customizable
characters. Based on `censor_it` Dart package. [GitHub](https://github.com/pavluke/censor_it) | [Pub.dev](https://pub.dev/packages/censor_it)

## Introduction

When it comes to censoring text in your Flutter application, you might need to
handle multiple languages and customize the characters used for censoring.
`CensorItWidget` provides an easy-to-use solution for this problem.

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

Add censor_it to your `pubspec.yaml`:
```yaml
dependencies:
  flutter_censor_it: ^<latest_version>
```

Import the package in your Dart file:

```dart
import 'package:flutter_censor_it/flutter_censor_it.dart';
```

You can now use the `CensorItWidget` to censor text:


```dart
// Base usage
CensorItWidget(
  	'Holy shit, it works!',
	// Censor pattern (default: ['!', '#', '%', '&', '?', '@', '\$']).
	chars = const ['*'],
	// Censor pattern (default: CensorPattern.all).
  	pattern = CensorPattern.english,
	// Just hide all swear words.
	// This implementation is the default if argument is not provided.
  	censoredWordBuilder: (context, word) => 
		Stack(
          children: [
            Text(word.origin),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
)

```

Result:

<a href="https://github.com/Pavluke/flutter_censor_it/blob/main/images/base_result.png?raw=true">
  <img src="https://github.com/Pavluke/flutter_censor_it/blob/main/images/base_result.png?raw=true" alt="Pub" width="200" />
</a>

## Features

- **Customizable Censor Patterns**: Use predefined censor patterns for multiple
  languages or create your own.
- **Customizable Censor Characters**: Define your own set of characters to use
  for censoring.
- **Profanity Detection**: Check if the text contains any profanity based on the
  censor pattern.

## Changelog

Please see the
[Changelog](https://github.com/pavluke/flutter_censor_it/blob/main/CHANGELOG.md) page to
know what's recently changed.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it,
please fill an [issue](https://github.com/pavluke/flutter_censor_it/issues).
If you fixed a bug or implemented a feature, please send a
[pull request](https://github.com/pavluke/flutter_censor_it/pulls).
