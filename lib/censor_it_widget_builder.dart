part of 'censor_it_widget_base.dart';

/// A function that generates replacement widgets for profane words.
typedef CensorWidgetBuilder =
    Widget Function(
      BuildContext context,
      String word,
    );

/// {@macro censor_it_widget.widget_builder}
final class CensorItWidgetBuilder extends CensorItWidget {
  /// {@macro censor_it_widget.widget_builder}
  const CensorItWidgetBuilder(
    super.text, {
    required this.builder,
    this.alignment,
    this.baseline,
    super.pattern,
    super.style,
    super.censoredStyle,
    super.key,
  });

  /// The function that generates replacement widgets.
  final CensorWidgetBuilder builder;

  /// Where to vertically align the placeholder relative
  /// to the surrounding text.
  final PlaceholderAlignment? alignment;

  /// A horizontal line used for aligning text.
  final TextBaseline? baseline;

  @override
  State<CensorItWidgetBuilder> createState() => _CensorItWidgetBuilderState();
}

class _CensorItWidgetBuilderState extends State<CensorItWidgetBuilder> {
  @override
  Widget build(BuildContext context) {
    final spanBuilder = WidgetSpanBuilder(
      censorIt: CensorIt.mask(
        widget.text,
        pattern: widget.pattern ?? LanguagePattern.all,
      ),
      style: widget.normalTextStyle(context),
      child: widget.builder(context, ''),
      alignment: widget.alignment ?? .middle,
      baseline: widget.baseline ?? .ideographic,
    );

    final spans = spanBuilder.buildSpans(revealAll: false);

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}
