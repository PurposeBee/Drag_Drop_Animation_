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

class _LinesState extends State<Lines> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late final controller = AnimationController(
      duration: const Duration(milliseconds: 3000), vsync: this);

  @override
  void initState() {
    super.initState();

    animation = Tween(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {
          
        });
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: CustomPaint(
            painter: LinesPainter(
                widget.start, widget.end, widget.color, animation.value)));
  }
}

class LinesPainter extends CustomPainter {
  final Offset start, end;
  final double progress;
  final Color color;
  LinesPainter(this.start, this.end, this.color, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
        start,
        end,
        // Offset(
        //   (start.dx * progress) + (end.dx * progress),
        //   end.dy - (end.dy * progress),
        // ),
        Paint()
          ..strokeWidth = 1
          ..color = color);
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
