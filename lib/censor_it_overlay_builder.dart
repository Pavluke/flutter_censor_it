part of 'censor_it_widget_base.dart';

/// A function that generates overlay widgets for profane words.
typedef CensorOverlayBuilder =
    Widget Function(
      BuildContext context,
      String word,
      bool isRevealed,
    );

/// {@macro censor_it_widget.overlay_builder}
final class CensorItOverlayBuilder extends CensorItWidget {
  /// {@macro censor_it_widget.overlay_builder}
  const CensorItOverlayBuilder(
    super.text, {
    required this.builder,
    super.pattern,
    super.style,
    super.censoredStyle,
    this.onTap,
    super.key,
  });

  /// The function that generates overlay widgets.
  final CensorOverlayBuilder builder;

  /// Callback for handling tap events on censored words.
  final bool Function(bool isRevealed)? onTap;

  @override
  State<CensorItOverlayBuilder> createState() => _CensorItOverlayBuilderState();
}

class _CensorItOverlayBuilderState extends State<CensorItOverlayBuilder> {
  bool _isRevealed = false;

  @override
  Widget build(BuildContext context) {
    final censorIt = CensorIt.mask(
      widget.text,
      pattern: widget.pattern ?? LanguagePattern.all,
    );

    if (!censorIt.hasProfanity) {
      return Text(
        widget.text,
        style: widget.normalTextStyle(context),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = widget.normalTextStyle(context);

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

          spans.add(
            TextSpan(
              text: originalWord,
              style: widget.censoredTextStyle(context),
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

        final painter = TextPainter(
          text: TextSpan(children: spans),
          textDirection: .ltr,
        )..layout(maxWidth: constraints.maxWidth);

        Widget textWidget = CustomPaint(
          size: Size(
            constraints.maxWidth,
            painter.height,
          ),
          painter: _TextPainterAdapter(
            textPainter: painter,
          ),
        );

        final overlays = <Widget>[];

        for (final match in censorIt.matches) {
          final boxes = painter.getBoxesForSelection(
            TextSelection(
              baseOffset: match.start,
              extentOffset: match.end,
            ),
          );

          final originalWord = widget.text.substring(
            match.start,
            match.end,
          );

          for (final box in boxes) {
            overlays.add(
              Positioned.fromRect(
                rect: box.toRect(),
                child: widget.builder(
                  context,
                  originalWord,
                  _isRevealed,
                ),
              ),
            );
          }
        }

        textWidget = SizedBox(
          width: constraints.maxWidth,
          height: painter.height,
          child: Stack(children: [textWidget, ...overlays]),
        );

        if (widget.onTap case final onTap?) {
          textWidget = GestureDetector(
            onTap: () => setState(() => _isRevealed = onTap(_isRevealed)),
            child: textWidget,
          );
        }

        return textWidget;
      },
    );
  }
}

class _TextPainterAdapter extends CustomPainter {
  _TextPainterAdapter({required this.textPainter});

  final TextPainter textPainter;

  @override
  void paint(Canvas canvas, Size size) => textPainter.paint(
    canvas,
    .zero,
  );

  @override
  bool shouldRepaint(_TextPainterAdapter oldDelegate) => false;
}
