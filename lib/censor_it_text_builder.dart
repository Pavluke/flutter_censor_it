part of 'censor_it_widget_base.dart';

/// A function that generates replacement text for profane words.
typedef CensorTextBuilder = String Function(BuildContext context, String word);

/// {@macro censor_it_widget.text_builder}
final class CensorItTextBuilder extends CensorItWidget {
  /// {@macro censor_it_widget.text_builder}
  const CensorItTextBuilder(
    super.text, {
    required this.builder,
    super.pattern,
    super.style,
    super.censoredStyle,
    super.key,
  });

  /// The function that generates replacement text.
  final CensorTextBuilder builder;

  @override
  State<CensorItTextBuilder> createState() => _CensorItTextBuilderState();
}

class _CensorItTextBuilderState extends State<CensorItTextBuilder> {
  @override
  Widget build(BuildContext context) {
    final censorIt = CensorIt.builder(
      widget.text,
      pattern: widget.pattern ?? LanguagePattern.all,
      builder: (word) => widget.builder(
        context,
        word,
      ),
    );

    if (!censorIt.hasProfanity) {
      return Text(
        widget.text,
        style: widget.normalTextStyle(context),
      );
    }

    if (widget.censoredStyle == null) {
      return Text(
        censorIt.censored,
        style: widget.normalTextStyle(context),
      );
    }

    final textStyle = widget.normalTextStyle(context);
    final censoredStyle = widget.censoredTextStyle(context);
    final spans = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in censorIt.matches) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: widget.text.substring(
              lastEnd,
              match.start,
            ),
            style: textStyle,
          ),
        );
      }

      final originalWord = widget.text.substring(
        match.start,
        match.end,
      );
      final censoredWord = widget.builder(
        context,
        originalWord,
      );

      spans.add(
        TextSpan(
          text: censoredWord,
          style: censoredStyle,
        ),
      );

      lastEnd = match.end;
    }

    if (lastEnd < widget.text.length) {
      spans.add(
        TextSpan(
          text: widget.text.substring(lastEnd),
          style: textStyle,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}
