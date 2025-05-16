import 'package:censor_it/censor_it.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef Word = ({String origin, String censored});

class CensorItWidget extends StatelessWidget {
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

  final CensorIt censorIt;
  final Widget Function(BuildContext context, Word word)? censoredWordBuilder;
  final TextStyle? style;
  final TextStyle? censoredStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final TextScaler textScaler;
  final int? maxLines;

  List<InlineSpan> _buildTextSpans(BuildContext context, String text) {
    final originalText = censorIt.origin;
    final censoredText = text;
    final List<InlineSpan> spans = [];
    final textStyle = style ?? Theme.of(context).textTheme.bodyMedium;

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
      if (start >= censoredText.length || end > censoredText.length) {}

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
                      textStyle: textStyle?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: textStyle.fontSize,
                      ),
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
