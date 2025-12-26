import 'package:censor_it/censor_it.dart';
import 'package:flutter/material.dart';

import '../../flutter_censor_it.dart';

/// {@template base_span_builder}
/// Abstract base class for building text spans with censored content.
///
/// This class provides a common interface for creating [InlineSpan] objects
/// that represent text with censored profanity. Subclasses must implement
/// [buildPlainSpan] and [buildCensoredSpan] to define how normal and
/// censored text are rendered.
///
/// The [buildSpans] method handles the logic of splitting text into spans,
/// calling the appropriate builder methods for normal and censored portions.
///
/// Type parameter:
/// * [TSpan] - The type of [InlineSpan] this builder creates
///
/// See also:
/// * [TextSpanBuilder] for text-based censoring
/// * [WidgetSpanBuilder] for widget-based censoring
/// {@endtemplate}
abstract class BaseSpanBuilder<TSpan extends InlineSpan> {
  /// {@macro base_span_builder}
  BaseSpanBuilder({
    required this.censorIt,
    required this.style,
  });

  /// The [CensorIt] instance containing censored text and match information.
  final CensorIt censorIt;

  /// The text style to apply to normal (non-censored) text.
  final TextStyle style;

  String get _text => censorIt.original;

  /// Returns the list of profanity matches found in the text.
  List<RegExpMatch> getMatches() => censorIt.matches;

  /// Builds a span for normal (non-censored) text.
  ///
  /// This method is called for text portions that do not contain profanity.
  ///
  /// Parameters:
  /// * [text] - The text content to render
  ///
  /// Returns a [TSpan] with the given text.
  TSpan buildPlainSpan(String text);

  /// Builds a span for censored (profane) text.
  ///
  /// This method is called for text portions that contain profanity.
  ///
  /// Parameters:
  /// * [originalWord] - The original profane word
  /// * [index] - The index of this word in the list of matches
  /// * [revealAll] - Whether to show the original word (true)
  /// or censored version (false)
  ///
  /// Returns a [TSpan] representing the censored word.
  TSpan buildCensoredSpan(String originalWord, int index, bool revealAll);

  /// Builds a list of spans representing the entire text with
  /// censoring applied.
  ///
  /// This method iterates through the text, creating spans for both normal
  /// and censored portions using [buildPlainSpan] and [buildCensoredSpan].
  ///
  /// Parameters:
  /// * [revealAll] - Whether to reveal all profane words (true)
  /// or censor them (false)
  ///
  /// Returns a list of [TSpan] objects representing the complete text.
  List<TSpan> buildSpans({bool revealAll = true}) {
    final matches = censorIt.matches;
    if (matches.isEmpty) {
      return [
        buildPlainSpan(_text),
      ];
    }

    final spans = <TSpan>[];
    int lastEnd = 0;
    int wordIndex = 0;

    for (final m in matches) {
      if (m.start > lastEnd) {
        spans.add(buildPlainSpan(_text.substring(lastEnd, m.start)));
      }

      final word = _text.substring(m.start, m.end);
      spans.add(buildCensoredSpan(word, wordIndex, revealAll));

      lastEnd = m.end;
      wordIndex++;
    }

    if (lastEnd < _text.length) {
      spans.add(buildPlainSpan(_text.substring(lastEnd)));
    }

    return spans;
  }
}
