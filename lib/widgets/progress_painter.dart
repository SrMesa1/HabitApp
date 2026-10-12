import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Dibuja un anillo de progreso circular usando Canvas.
class PintorProgreso extends CustomPainter {
  final double progreso; // valor entre 0.0 y 1.0
  final Color color;

  PintorProgreso({required this.progreso, required this.color});

  @override
  void paint(Canvas canvas, Size tamano) {
    final centro = Offset(tamano.width / 2, tamano.height / 2);
    final radio = math.min(tamano.width, tamano.height) / 2 - 10;

    // Anillo de fondo
    final fondo = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawCircle(centro, radio, fondo);

    // Arco de progreso
    final arco = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: centro, radius: radio),
      -math.pi / 2,
      2 * math.pi * progreso,
      false,
      arco,
    );

    // Porcentaje en el centro
    final pintorTexto = TextPainter(
      text: TextSpan(
        text: '${(progreso * 100).round()}%',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    pintorTexto.paint(
      canvas,
      centro - Offset(pintorTexto.width / 2, pintorTexto.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant PintorProgreso delegadoAnterior) =>
      delegadoAnterior.progreso != progreso ||
      delegadoAnterior.color != color;
}
