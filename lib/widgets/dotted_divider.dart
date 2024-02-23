
import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  const DottedDivider({super.key});


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1.0), // Kích thước của vùng vẽ, có thể điều chỉnh tùy ý
      painter: DottedLinePainter(),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5) // Màu của nét dứt
      ..strokeWidth = 1.2 // Độ dày của nét dứt
      ..strokeCap = StrokeCap.round;

    const double dashWidth = 10.0; // Chiều dài của mỗi đoạn nét dứt
    const double dashSpace = 5.0; // Khoảng cách giữa các đoạn nét dứt

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0.0), Offset(startX + dashWidth, 0.0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}