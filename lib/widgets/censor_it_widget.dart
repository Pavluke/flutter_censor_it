import 'package:censor_it/censor_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A tuple representing an original word and its censored counterpart.
typedef Word = ({String origin, String censored});

/// A widget that displays text with masked profanity segments.
///
/// The [CensorItWidget] processes the given [text] and replaces any words
/// matching the specified [pattern] with masked characters from [chars].
/// It renders the resulting string as a [RichText], allowing for customization
/// of both normal and censored word styles, as well as providing a builder
/// callback for fully custom censored-word widgets.
class CensorItWidget extends StatelessWidget {
  /// Creates a [CensorItWidget].
  ///
  /// The [text] argument is the source string to display and censor.
  ///
  /// The [chars] list defines the set of characters used to mask profanity.
  /// Defaults to `['!', '#', '%', '&', '?', '@', '\$']`.
  ///
  /// The [pattern] controls which words are considered profane.
  /// Defaults to [CensorPattern.all].
  ///
  /// The [censoredWordBuilder] callback, if provided, will be invoked for each
  /// censored word, allowing custom widget rendering of masked segments.
  ///
  /// The [style] and [censoredStyle] define text styles for normal and censored
  /// segments, respectively.
  ///
  /// [textAlign], [textDirection], [softWrap], [overflow], [textScaler], and
  /// [maxLines] are forwarded to the underlying [RichText] widget.
  CensorItWidget(
    String text, {
    super.key,
    List<String> chars = const ['!', '#', '%', '&', '?', '@', '\$'],
    CensorPattern pattern = CensorPattern.all,
    this.censoredWordBuilder,
    this.style,
    this.censoredStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaler = TextScaler.noScaling,
    this.maxLines,
  }) : censorIt = CensorIt(text, chars: chars, pattern: pattern);

  /// The [CensorIt] instance used to perform the censorship logic.
  final CensorIt censorIt;

  /// Optional builder for fully custom rendering of each censored segment.
  ///
  /// Called with the build [context] and a [Word] tuple containing
  /// the [origin] and [censored] strings.
  final Widget Function(BuildContext context, Word word)? censoredWordBuilder;

  /// Text style for non-censored segments.
  final TextStyle? style;

  /// Text style for censored segments.
  /// Recommendation: use monospaced fonts,
  /// as the standard one has different character widths.
  final TextStyle? censoredStyle;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text (e.g., ltr, rtl).
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// Controls text scaling behavior.
  final TextScaler textScaler;

  /// The maximum number of lines to display.
  final int? maxLines;

  /// Builds the list of [InlineSpan]s for the input [text], splitting into
  /// normal and censored segments.
  ///
  /// Each match of profane words in the original text is replaced by either
  /// a default-styled masked segment or a custom widget via
  /// [censoredWordBuilder].
  List<InlineSpan> _buildTextSpans(BuildContext context, String text) {
    final originalText = censorIt.origin;
    final censoredText = text;
    final spans = <InlineSpan>[];
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: style?.color ?? Theme.of(context).textTheme.bodyMedium?.color,
      fontSize: style?.fontSize,
      fontFamily: style?.fontFamily,
      fontWeight: style?.fontWeight,
      fontFamilyFallback: style?.fontFamilyFallback,
      fontFeatures: style?.fontFeatures,
      fontStyle: style?.fontStyle,
      fontVariations: style?.fontVariations,
      foreground: style?.foreground,
      wordSpacing: style?.wordSpacing,
      textBaseline: style?.textBaseline,
      debugLabel: style?.debugLabel,
      decoration: style?.decoration,
      decorationColor: style?.decorationColor,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      inherit: style?.inherit,
    );

    if (originalText.isEmpty) {
      return spans;
    }

    if (!censorIt.hasProfanity) {
      return [TextSpan(text: originalText, style: textStyle)];
    }

    final swearWords = censorIt.swearWords.join('|');
    final regex = RegExp(swearWords);

    int lastEnd = 0;

    for (final match in regex.allMatches(originalText.toLowerCase())) {
      final start = match.start;
      final end = match.end;

      if (start > lastEnd) {
        spans.add(
          TextSpan(
            text: originalText.substring(lastEnd, start),
            style: textStyle,
          ),
        );
      }

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Builder(
            builder: (context) {
              final origin = originalText.substring(start, end);
              final censored = censoredText.substring(start, end);
              return DefaultTextStyle(
                style:
                    censoredStyle ??
                    GoogleFonts.robotoMono(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: textStyle?.fontSize,
                    ),
                child:
                    censoredWordBuilder?.call(context, (
                      censored: censored,
                      origin: origin,
                    )) ??
                    Stack(
                      children: [
                        Text(censored),
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
              );
            },
          ),
        ),
      );

      lastEnd = end;
    }

    if (lastEnd < originalText.length) {
      spans.add(
        TextSpan(text: originalText.substring(lastEnd), style: textStyle),
      );
    }

    return spans;
  }

  /// Builds the [RichText] widget displaying the fully processed text.
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: _buildTextSpans(context, censorIt.toString())),
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaler: textScaler,
      softWrap: softWrap,
    );
  }
}
