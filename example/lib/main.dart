import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_censor_it/flutter_censor_it.dart';

void main() => runApp(const Example());

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  String text = '';
  bool isAnimated = false;
  int style = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('flutter_censor_it'), centerTitle: true),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                spacing: 15,
                children: [
                  DropdownMenu(
                    initialSelection: style,
                    onSelected:
                        (value) => setState(() => style = value ?? style),
                    dropdownMenuEntries: List.generate(
                      2,
                      (index) => DropdownMenuEntry(
                        value: index,
                        label: 'Style ${index + 1}',
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        text.isNotEmpty
                            ? SingleChildScrollView(
                              child: CensorItWidget(
                                text,
                                censoredWordBuilder:
                                    (context, word) => switch (style) {
                                      0 => Builder(
                                        builder: (context) {
                                          bool isVisible = false;
                                          return StatefulBuilder(
                                            builder:
                                                (
                                                  context,
                                                  setState,
                                                ) => GestureDetector(
                                                  onTap:
                                                      () => setState(
                                                        () =>
                                                            isVisible =
                                                                !isVisible,
                                                      ),

                                                  child: Stack(
                                                    children: [
                                                      Text(
                                                        word.origin,
                                                        style:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium,
                                                      ),
                                                      Positioned.fill(
                                                        child: AnimatedOpacity(
                                                          duration: Duration(
                                                            milliseconds: 100,
                                                          ),
                                                          opacity:
                                                              isVisible ? 0 : 1,
                                                          child: DecoratedBox(
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .primary,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    5,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          );
                                        },
                                      ),
                                      1 => AnimatedCensoredText(word.origin),
                                      _ => SizedBox(),
                                    },
                              ),
                            )
                            : Center(
                              child: Text(
                                'There will be censored text...',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) => setState(() => text = value),
                      decoration: InputDecoration(hintText: 'Enter text...'),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedCensoredText extends StatefulWidget {
  const AnimatedCensoredText(this.text, {super.key});

  final String text;

  @override
  State<AnimatedCensoredText> createState() => _AnimatedCensoredTextState();
}

class _AnimatedCensoredTextState extends State<AnimatedCensoredText>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  late CensorIt censorIt;

  @override
  void initState() {
    super.initState();
    censorIt = CensorIt(widget.text);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Timer.periodic(Duration(milliseconds: 200), (_) {
      if (mounted) setState(() => censorIt.regenerateCensoredText());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder:
          (context, _) => Transform.rotate(
            angle: 1 - _animation.value,
            child: Transform.scale(
              scale: _animation.value,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(censorIt.toString()),
              ),
            ),
          ),
    );
  }
}
