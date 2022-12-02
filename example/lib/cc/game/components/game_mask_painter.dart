import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../helpers/Constants.dart';

class PoseMaskPainter extends CustomPainter {
  PoseMaskPainter({
    required this.pose,
    required this.mask,
    required this.imageSize,
  });

  //static const double Y = 0;
  final Pose? pose;
  final ui.Image? mask;
  final Size imageSize;

  //點的顏色
  final PointPaint = Paint()
    ..color = const Color.fromRGBO(100, 208, 218, 1);

  @override
  void paint(Canvas canvas, Size size) {
    _paintPose(canvas, size);
  }

  void _paintPose(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio =
        imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
        imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

    // Landmark connections 線段連線
    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};

    Offset nose = offsetForPart(landmarksByType[PoseLandmarkType.rightIndexFinger]!);
    getY = nose.dy;

  /*  print("////////////////");
    print("${nose.dy} ////////////////");
    print("${nose} ////////////////");
    */

    //只畫單點
    canvas.drawCircle(nose, 5, PointPaint);

     for (final part in pose!.landmarks) {
      // Landmark labels
      TextSpan span = TextSpan(
        text: nose.dy.toString(),
        style: const TextStyle(
          color: Color.fromRGBO(0, 128, 255, 1),
          fontSize: 10,
          shadows: [
            ui.Shadow(
              color: Color.fromRGBO(255, 255, 255, 1),
              offset: Offset(1, 1),
              blurRadius: 1,
            ),
          ],
        ),
      );
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr; //文字對齊方向，對齊左邊
      tp.layout();
      tp.paint(canvas, nose);
    }
  }

  @override
  bool shouldRepaint(PoseMaskPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.mask != mask ||
        oldDelegate.imageSize != imageSize;
  }
}
