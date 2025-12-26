import 'package:censor_it/censor_it.dart';
import 'package:flutter/material.dart';

import 'utils/utils.dart';

part 'censor_it_overlay_builder.dart';
part 'censor_it_text_builder.dart';
part 'censor_it_widget_builder.dart';

/// {@template censor_it_widget}
/// A sealed widget for censoring profanity in text.
///
/// Supports three strategies:
/// * [textBuilder] - Replace profanity with custom text
/// * [widgetBuilder] - Replace profanity with custom widgets
/// * [overlayBuilder] - Apply visual effects over profanity
/// {@endtemplate}
sealed class CensorItWidget extends StatefulWidget {
  /// {@macro censor_it_widget}
  ///
  /// This constructor is protected and should not be called directly.
  /// Use one of the factory constructors instead:
  /// * [CensorItWidget.textBuilder]
  /// * [CensorItWidget.widgetBuilder]
  /// * [CensorItWidget.overlayBuilder]
  const CensorItWidget(
    this.text, {
    this.pattern,
    this.style,
    this.censoredStyle,
    super.key,
  });

  /// {@template censor_it_widget.text_builder}
  /// Creates a widget that replaces profanity with custom text.
  ///
  /// Example:
  /// ```dart
  /// CensorItWidget.textBuilder(
  ///   'Fuck this!',
  ///   builder: (context, word) => '[censored]',
  ///   pattern: LanguagePattern.english,
  /// )
  /// ```
  /// {@endtemplate}
  const factory CensorItWidget.textBuilder(
    String text, {
    required CensorTextBuilder builder,
    CensorPattern? pattern,
    TextStyle? style,
    TextStyle? censoredStyle,
    Key? key,
  }) = CensorItTextBuilder;

  /// {@template censor_it_widget.widget_builder}
  /// Creates a widget that replaces profanity with custom widgets.
  ///
  /// Example:
  /// ```dart
  /// CensorItWidget.widgetBuilder(
  ///   'Fuck this!',
  ///   builder: (context, word) => Icon(Icons.block),
  ///   pattern: LanguagePattern.english,
  /// )
  /// ```
  /// {@endtemplate}
  const factory CensorItWidget.widgetBuilder(
    String text, {
    required CensorWidgetBuilder builder,
    PlaceholderAlignment? alignment,
    TextBaseline? baseline,
    CensorPattern? pattern,
    TextStyle? style,
    Key? key,
  }) = CensorItWidgetBuilder;

  /// {@template censor_it_widget.overlay_builder}
  /// Creates a widget that applies visual overlays over profanity.
  ///
  /// Example:
  /// ```dart
  /// CensorItWidget.overlayBuilder(
  ///   'Fuck this!',
  ///   builder: (context, word, revealed) => Container(
  ///     color: Colors.black.withOpacity(0.8),
  ///   ),
  ///   pattern: LanguagePattern.english,
  /// )
  /// ```
  /// {@endtemplate}
  const factory CensorItWidget.overlayBuilder(
    String text, {
    required CensorOverlayBuilder builder,
    CensorPattern? pattern,
    TextStyle? style,
    TextStyle? censoredStyle,
    bool Function(bool)? onTap,
    Key? key,
  }) = CensorItOverlayBuilder;

  /// The text to be censored.
  final String text;

  /// The language pattern for profanity detection.
  final CensorPattern? pattern;

  /// Text style for normal (non-profane) text.
  final TextStyle? style;

  /// Text style for censored (profane) words.
  final TextStyle? censoredStyle;

  TextStyle _mergedStyle(
    BuildContext context, {
    TextStyle? override,
  }) {
    final themeStyle =
        Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    return themeStyle.merge(override ?? style);
  }

  /// @nodoc
  TextStyle normalTextStyle(BuildContext context) => _mergedStyle(context);

  /// @nodoc
  TextStyle censoredTextStyle(BuildContext context) =>
      _mergedStyle(context, override: censoredStyle);
}
