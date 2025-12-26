import 'package:flutter/material.dart';

import 'base_span_builder.dart';

/// {@template widget_span_builder}
/// A span builder that creates [WidgetSpan] objects for censored text.
///
/// {@macro base_span_builder}
///
/// This implementation replaces censored words with widgets using [WidgetSpan].
/// When [revealAll] is true, the original text is shown instead of the widget.
///
/// Example:
/// ```dart
/// final builder = WidgetSpanBuilder(
///   censorIt: CensorIt.mask('Fuck this!'),
///   style: TextStyle(color: Colors.black),
///   child: Icon(Icons.block, size: 16),
///   alignment: .middle,
/// );
/// final spans = builder.buildSpans(revealAll: false);
/// ```
/// {@endtemplate}
class WidgetSpanBuilder extends BaseSpanBuilder<InlineSpan> {
  /// {@macro widget_span_builder}
  WidgetSpanBuilder({
    required super.censorIt,
    required super.style,
    required this.child,
    this.alignment = .middle,
    this.baseline = .ideographic,
  });

  /// The widget to display in place of censored words.
  final Widget child;

  /// How to align the widget vertically within the text line.
  final PlaceholderAlignment alignment;

  /// The baseline to use when [alignment] is [.baseline].
  final TextBaseline? baseline;

  @override
  InlineSpan buildPlainSpan(String text) => TextSpan(
    text: text,
    style: style,
  );

  @override
  InlineSpan buildCensoredSpan(
    String originalWord,
    int index,
    bool revealedAll,
  ) => revealedAll
      ? TextSpan(text: originalWord, style: style)
      : WidgetSpan(
          alignment: alignment,
          baseline: baseline,
          child: child,
        );
}
