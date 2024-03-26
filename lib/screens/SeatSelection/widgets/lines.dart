import 'package:flutter/material.dart';

class Lines extends StatefulWidget {
  final Offset start;
  final Offset end;
  final Color color;

  const Lines(
      {super.key, required this.start, required this.end, required this.color});

  @override
  createState() => _LinesState();
}

class _LinesState extends State<Lines> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: CustomPaint(painter: LinesPainter(widget.start, widget.end, widget.color)));
  }
}

class LinesPainter extends CustomPainter {
  final Offset start, end;
  final Color color;
  LinesPainter(this.start, this.end, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        start,
        end,
        Paint()
          ..strokeWidth = 1
          ..color = color);
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
