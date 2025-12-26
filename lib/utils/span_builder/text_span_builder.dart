import 'package:flutter/material.dart';

import 'base_span_builder.dart';
import 'span_builder.dart';

/// {@template text_span_builder}
/// A span builder that creates [TextSpan] objects for censored text.
///
/// {@macro base_span_builder}
///
/// This implementation creates text-only spans, applying [censoredStyle]
/// to censored portions and [style] to normal portions.
///
/// Example:
/// ```dart
/// final builder = TextSpanBuilder(
///   censorIt: CensorIt.mask('Fuck this!'),
///   style: TextStyle(color: Colors.black),
///   censoredStyle: TextStyle(
///     color: Colors.red,
///     fontWeight: .bold,
///   ),
/// );
/// final spans = builder.buildSpans(
///   revealAll: false,
/// );
/// ```
/// {@endtemplate}
class TextSpanBuilder extends BaseSpanBuilder<TextSpan> {
  /// {@macro text_span_builder}
  TextSpanBuilder({
    required super.censorIt,
    required super.style,
    required this.censoredStyle,
  });

  /// The text style to apply to censored (profane) text.
  final TextStyle censoredStyle;

  @override
  TextSpan buildPlainSpan(String text) => TextSpan(
    text: text,
    style: style,
  );

  @override
  TextSpan buildCensoredSpan(
    String originalWord,
    int index,
    bool revealAll,
  ) => TextSpan(
    text: revealAll ? originalWord : censorIt.censored,
    style: censoredStyle,
  );
}
