import 'dart:math';
import 'package:flutter/material.dart';

class AudioWaveform extends StatelessWidget {
  final bool isMe;
  final Duration duration;

  const AudioWaveform({super.key, required this.isMe, required this.duration});

  @override
  Widget build(BuildContext context) {
    final double width = (duration.inSeconds * 10.0).clamp(60.0, 160.0);

    return CustomPaint(
      size: Size(width, 24),
      painter: _WaveformPainter(
        color: isMe ? const Color(0xFF559D69) : const Color(0xFF517DA2),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final Color color;
  final List<double> _bars;

  _WaveformPainter({required this.color})
      : _bars = List.generate(40, (index) => Random().nextDouble());

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final double spacing = 4.0;
    final int count = (size.width / spacing).floor();

    for (int i = 0; i < count; i++) {
      final double barHeight = _bars[i % _bars.length] * size.height;
      final double actualHeight = barHeight < 4 ? 4 : barHeight;
      final double x = i * spacing;
      final double y = (size.height - actualHeight) / 2;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + actualHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
