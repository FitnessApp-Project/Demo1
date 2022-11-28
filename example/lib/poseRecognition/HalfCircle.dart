import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';

import 'package:body_detection/models/point3d.dart';
import 'dart:math';
import 'provider.dart' as globals;

import 'dart:math' as math;
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

class HalfCircle extends CustomPainter {
  HalfCircle(

      );
  double _kCurveHeight = 35;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(size.width / 2, 2 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(p, Paint()..color = Colors.yellow);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }


}

