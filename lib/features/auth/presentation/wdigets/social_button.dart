import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey.shade700,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Vector Google Icon menggunakan CustomPainter (tanpa butuh asset gambar)
                  const _GoogleIcon(),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Widget internal untuk menggambar Logo Google (4 Warna Resmi)
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Red Arc
    paint.color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(w * 0.5, h * 0.19)
      ..cubicTo(w * 0.64, h * 0.19, w * 0.76, h * 0.24, w * 0.85, h * 0.32)
      ..lineTo(w * 0.98, h * 0.19)
      ..cubicTo(w * 0.86, h * 0.07, w * 0.69, 0, w * 0.5, 0)
      ..cubicTo(w * 0.3, 0, w * 0.13, h * 0.11, w * 0.05, h * 0.28)
      ..lineTo(w * 0.22, h * 0.41)
      ..cubicTo(w * 0.26, h * 0.28, w * 0.37, h * 0.19, w * 0.5, h * 0.19);
    canvas.drawPath(redPath, paint);

    // Blue Bar/Arc
    paint.color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(w * 0.98, h * 0.51)
      ..cubicTo(w * 0.98, h * 0.48, w * 0.97, h * 0.43, w * 0.96, h * 0.4)
      ..lineTo(w * 0.5, h * 0.4)
      ..lineTo(w * 0.5, h * 0.6)
      ..lineTo(w * 0.78, h * 0.6)
      ..cubicTo(w * 0.76, h * 0.7, w * 0.7, h * 0.78, w * 0.61, h * 0.84)
      ..lineTo(w * 0.78, h * 0.97)
      ..cubicTo(w * 0.9, h * 0.86, w * 0.98, h * 0.7, w * 0.98, h * 0.51);
    canvas.drawPath(bluePath, paint);

    // Yellow Arc
    paint.color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(w * 0.22, h * 0.41)
      ..cubicTo(w * 0.2, h * 0.47, w * 0.19, h * 0.53, w * 0.19, h * 0.6)
      ..cubicTo(w * 0.19, h * 0.67, w * 0.2, h * 0.73, w * 0.22, h * 0.79)
      ..lineTo(w * 0.05, h * 0.92)
      ..cubicTo(0, h * 0.82, 0, h * 0.71, 0, h * 0.6)
      ..cubicTo(0, h * 0.49, 0, h * 0.38, w * 0.05, h * 0.28)
      ..lineTo(w * 0.22, h * 0.41);
    canvas.drawPath(yellowPath, paint);

    // Green Arc
    paint.color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(w * 0.5, h * 1.0)
      ..cubicTo(w * 0.68, h * 1.0, w * 0.83, h * 0.94, w * 0.93, h * 0.84)
      ..lineTo(w * 0.77, h * 0.72)
      ..cubicTo(w * 0.7, h * 0.77, w * 0.61, h * 0.81, w * 0.5, h * 0.81)
      ..cubicTo(w * 0.37, h * 0.81, w * 0.26, h * 0.72, w * 0.22, h * 0.59)
      ..lineTo(w * 0.05, h * 0.72)
      ..cubicTo(w * 0.13, h * 0.89, w * 0.3, h * 1.0, w * 0.5, h * 1.0);
    canvas.drawPath(greenPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
