import 'package:flutter/material.dart';

/// Ícones de marcas personalizados para login
class BrandIcons {
  /// Ícone do Google personalizado
  static Widget google({double size = 24, Color? color}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: GoogleIconPainter(color: color)),
    );
  }

  /// Ícone da Microsoft personalizado
  static Widget microsoft({double size = 24, Color? color}) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: MicrosoftIconPainter(color: color)),
    );
  }
}

/// Painter para o ícone do Google
class GoogleIconPainter extends CustomPainter {
  final Color? color;

  GoogleIconPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.blue
      ..style = PaintingStyle.fill;

    // Desenhar o "G" do Google de forma simplificada

    // Círculo externo
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.4,
      paint..color = Colors.red.withOpacity(0.8),
    );

    // Desenhar detalhes coloridos do Google
    // Azul
    paint.color = Colors.blue;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.7,
        height: size.height * 0.7,
      ),
      0,
      3.14159 / 2,
      true,
      paint,
    );

    // Verde
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.7,
        height: size.height * 0.7,
      ),
      3.14159 / 2,
      3.14159 / 2,
      true,
      paint,
    );

    // Amarelo
    paint.color = Colors.yellow.shade700;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.7,
        height: size.height * 0.7,
      ),
      3.14159,
      3.14159 / 2,
      true,
      paint,
    );

    // Vermelho
    paint.color = Colors.red;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.7,
        height: size.height * 0.7,
      ),
      -3.14159 / 2,
      3.14159 / 2,
      true,
      paint,
    );

    // Centro branco
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.25,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter para o ícone da Microsoft
class MicrosoftIconPainter extends CustomPainter {
  final Color? color;

  MicrosoftIconPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Quadrados coloridos da Microsoft
    final squareSize = size.width * 0.35;
    final spacing = size.width * 0.05;

    // Vermelho (superior esquerdo)
    paint.color = Colors.red.shade600;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.1,
        squareSize,
        squareSize,
      ),
      paint,
    );

    // Verde (superior direito)
    paint.color = Colors.green.shade600;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1 + squareSize + spacing,
        size.height * 0.1,
        squareSize,
        squareSize,
      ),
      paint,
    );

    // Azul (inferior esquerdo)
    paint.color = Colors.blue.shade600;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.1 + squareSize + spacing,
        squareSize,
        squareSize,
      ),
      paint,
    );

    // Amarelo (inferior direito)
    paint.color = Colors.orange.shade600;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.1 + squareSize + spacing,
        size.height * 0.1 + squareSize + spacing,
        squareSize,
        squareSize,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
