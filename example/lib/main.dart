import 'package:flutter/material.dart';
import 'package:flutter_censor_it/flutter_censor_it.dart';

void main() => runApp(const MaterialApp(home: CensorExamplesPage()));

class CensorExamplesPage extends StatefulWidget {
  const CensorExamplesPage({super.key});

  @override
  State<CensorExamplesPage> createState() => _CensorExamplesPageState();
}

class _CensorExamplesPageState extends State<CensorExamplesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _textController;
  var _currentText =
      'This is a fucking example with some shit words and bitch ass profanity to test the censor';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _textController = TextEditingController(text: _currentText);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.grey[50],
    appBar: AppBar(
      title: const Text(
        'Flutter CensorIt Demo',
        style: TextStyle(fontWeight: .w600),
      ),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(text: 'Text Builder'),
          Tab(text: 'Widget Builder'),
          Tab(text: 'Overlay Builder'),
        ],
      ),
    ),
    body: Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              TextBuilderTab(text: _currentText),
              WidgetBuilderTab(text: _currentText),
              OverlayBuilderTab(text: _currentText),
            ],
          ),
        ),
        _InputSection(
          textController: _textController,
          onSend: () => setState(() => _currentText = _textController.text),
        ),
      ],
    ),
  );
}

class TextBuilderTab extends StatelessWidget {
  const TextBuilderTab({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const .all(24),
    child: Column(
      spacing: 16,
      crossAxisAlignment: .start,
      children: [
        _InfoCard(
          icon: Icons.text_fields,
          title: 'Text Builder Mode',
          description: 'Replace profanity with custom text',
          color: Colors.blue,
        ),
        _ResultCard(
          child: CensorItWidget.textBuilder(
            text,
            builder: (context, word) => '[censored]',
            pattern: LanguagePattern.english,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.black87,
            ),
            censoredStyle: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.red,
              fontWeight: .bold,
            ),
          ),
        ),
        _ResultCard(
          child: CensorItWidget.textBuilder(
            text,
            builder: (context, word) => '*' * word.length,
            pattern: LanguagePattern.english,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.black87,
            ),
            censoredStyle: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.orange,
              fontWeight: .w900,
            ),
          ),
        ),
      ],
    ),
  );
}

class WidgetBuilderTab extends StatelessWidget {
  const WidgetBuilderTab({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const .all(24),
    child: Column(
      spacing: 16,
      crossAxisAlignment: .start,
      children: [
        _InfoCard(
          icon: Icons.emoji_emotions,
          title: 'Widget Builder Mode',
          description: 'Replace profanity with custom widgets',
          color: Colors.orange,
        ),
        _ResultCard(
          child: CensorItWidget.widgetBuilder(
            text,
            pattern: LanguagePattern.english,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.black87,
            ),
            builder: (context, word) =>
                const Icon(Icons.no_adult_content, size: 20, color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

class OverlayBuilderTab extends StatelessWidget {
  const OverlayBuilderTab({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const .all(24),
    child: Column(
      spacing: 16,
      crossAxisAlignment: .start,
      children: [
        _InfoCard(
          icon: Icons.blur_on,
          title: 'Overlay Builder Mode',
          description: 'Apply effects over profanity. Tap to reveal!',
          color: Colors.purple,
        ),
        _ExampleLabel('Blur Effect (Tap to reveal)'),
        _ResultCard(
          child: CensorItWidget.overlayBuilder(
            text,
            pattern: LanguagePattern.english,
            onTap: (isRevealed) => !isRevealed,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.black87,
            ),
            censoredStyle: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.red,
              fontWeight: .bold,
            ),
            builder: (context, word, isRevealed) => TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: isRevealed ? 0.0 : 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, child) => ClipRRect(
                child: BackdropFilter(
                  filter: .blur(sigmaX: 5 * value, sigmaY: 5 * value),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1 * value),
                      borderRadius: .circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        _ExampleLabel('Dark Overlay (Tap to reveal)'),
        _ResultCard(
          child: CensorItWidget.overlayBuilder(
            text,
            pattern: LanguagePattern.english,
            onTap: (isRevealed) => !isRevealed,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.black87,
            ),
            censoredStyle: const TextStyle(
              fontSize: 18,
              height: 1.5,
              fontWeight: .bold,
            ),
            builder: (context, word, isRevealed) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isRevealed
                    ? Colors.transparent
                    : Colors.black.withValues(alpha: 0.85),
                borderRadius: .circular(4),
              ),
              child: isRevealed
                  ? null
                  : const Center(
                      child: Text(
                        '18+',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
            ),
          ),
        ),
        _ExampleLabel('Blocked Gradient Overlay'),
        _ResultCard(
          child: CensorItWidget.overlayBuilder(
            text,
            pattern: LanguagePattern.english,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Colors.black87,
            ),
            censoredStyle: const TextStyle(
              fontSize: 18,
              height: 1.5,
              fontWeight: .bold,
              letterSpacing: 1,
            ),
            builder: (context, word, isRevealed) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: isRevealed
                    ? null
                    : const LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                      ),
                borderRadius: .circular(8),
                border: .all(
                  color: isRevealed ? Colors.transparent : Colors.white,
                  width: 2,
                ),
              ),
              child: isRevealed
                  ? null
                  : const Center(
                      child: Icon(Icons.lock, color: Colors.white, size: 14),
                    ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ExampleLabel extends StatelessWidget {
  const _ExampleLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .only(bottom: 8, left: 4),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: .w600,
        color: Colors.grey[700],
      ),
    ),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const .all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: .circular(12),
      border: .all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(
      spacing: 16,
      children: [
        Container(
          padding: const .all(12),
          decoration: BoxDecoration(color: color, borderRadius: .circular(8)),
          child: Icon(icon, color: Colors.white, size: 24),
        ),

        Expanded(
          child: Column(
            spacing: 4,
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: .bold, color: color),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const .all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: .circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

class _InputSection extends StatelessWidget {
  const _InputSection({required this.textController, required this.onSend});

  final TextEditingController textController;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
      child: Padding(
        padding: const .all(16),
        child: Row(
          spacing: 12,
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Enter text to check...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: .circular(12),
                    borderSide: .none,
                  ),
                  contentPadding: const .symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.deepPurple,
              borderRadius: .circular(12),
              child: InkWell(
                onTap: onSend,
                borderRadius: .circular(12),
                child: Container(
                  padding: const .all(14),
                  child: const Icon(Icons.send, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
