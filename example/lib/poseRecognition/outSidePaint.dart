import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';

import 'package:body_detection/models/point3d.dart';
import 'dart:math';
import 'provider.dart' as globals;

class outSidePaint extends CustomPainter {
  outSidePaint();
  final GlobalKey _globalKey= GlobalKey();
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 10;
    canvas.drawRect(Offset(0 ,0) & const Size(360,566), paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}