import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1200),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          int dots = (_controller.value * 4).floor() % 4;
          return Text(
            'Gemini is typing${'.' * dots}',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          );
        },
      ),
    );
  }
}
