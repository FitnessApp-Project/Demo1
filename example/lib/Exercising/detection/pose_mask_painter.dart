import 'dart:ui' as ui;
import 'package:body_detection_example/Exercising/detection/verify.dart';
import 'package:flutter/widgets.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';

class PoseMaskPainter extends CustomPainter {
  PoseMaskPainter({
    required this.pose,
    required this.mask,
    required this.imageSize,
  });

  final Pose? pose;
  final ui.Image? mask;
  final Size imageSize;
  final pointPaint = Paint()..color = const Color.fromRGBO(255, 255, 255, 0.8);

  //分左右半邊的點點顏色
  final leftPointPaint = Paint()..color = const Color.fromRGBO(223, 157, 80, 1);
  final rightPointPaint = Paint()
    ..color = const Color.fromRGBO(100, 208, 218, 1);

  //節點之間連線的線段
  final linePaint = Paint()
    ..color = const Color.fromRGBO(255, 255, 255, 0.9)
    ..strokeWidth = 3;

  //去背，背去掉地方的設定
  final maskPaint = Paint()
    ..colorFilter = const ColorFilter.mode(
        Color.fromRGBO(0, 0, 255, 0.5), BlendMode.srcOut);

  //-----------test---------------
  final testlinePaint = Paint()
    ..color = const Color.fromRGBO(255, 12, 12, 0.9019607843137255)
    ..strokeWidth = 3;

  @override
  void paint(Canvas canvas, Size size) {
    _paintMask(canvas, size);
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
    for (final connection in connections) {
      final point1 = offsetForPart(landmarksByType[connection[0]]!);
      final point2 = offsetForPart(landmarksByType[connection[1]]!);
      canvas.drawLine(point1, point2, linePaint);

      //--test----------------
      //畫紅線標示，測試方便看
      canvas.drawLine(
          offsetForPart(landmarksByType[PoseLandmarkType.leftElbow]!),
          offsetForPart(landmarksByType[PoseLandmarkType.leftShoulder]!),
          testlinePaint);
      canvas.drawLine(
          offsetForPart(landmarksByType[PoseLandmarkType.leftWrist]!),
          offsetForPart(landmarksByType[PoseLandmarkType.leftElbow]!),
          testlinePaint);

      //PoseLandmarkType.leftElbow左肘
      //PoseLandmarkType.leftShoulder左肩
      //PoseLandmarkType.leftWrist左手腕
      Verify v = new Verify();
      v.setAngle(
          offsetForPart(landmarksByType[PoseLandmarkType.leftElbow]!),
          offsetForPart(landmarksByType[PoseLandmarkType.leftShoulder]!),
          offsetForPart(landmarksByType[PoseLandmarkType.leftWrist]!));
      //--test----------------
    }

    for (final part in pose!.landmarks) {
      // Landmark points
      canvas.drawCircle(offsetForPart(part), 5, pointPaint);
      if (part.type.isLeftSide) {
        canvas.drawCircle(offsetForPart(part), 3, leftPointPaint);
      } else if (part.type.isRightSide) {
        canvas.drawCircle(offsetForPart(part), 3, rightPointPaint);
      }


      // Landmark labels
      TextSpan span = TextSpan(
        text: part.type.toString().substring(16),
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
      tp.paint(canvas, offsetForPart(part));
    }
  }

  void _paintMask(Canvas canvas, Size size) {
    if (mask == null) return;
    canvas.drawImageRect(
        mask!,
        Rect.fromLTWH(0, 0, mask!.width.toDouble(), mask!.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        maskPaint);
  }

  @override
  bool shouldRepaint(PoseMaskPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.mask != mask ||
        oldDelegate.imageSize != imageSize;
  }

  //身體節點p1跟p2清單
  List<List<PoseLandmarkType>> get connections => [
        [PoseLandmarkType.leftEar, PoseLandmarkType.leftEyeOuter],
        [PoseLandmarkType.leftEyeOuter, PoseLandmarkType.leftEye],
        [PoseLandmarkType.leftEye, PoseLandmarkType.leftEyeInner],
        [PoseLandmarkType.leftEyeInner, PoseLandmarkType.nose],
        [PoseLandmarkType.nose, PoseLandmarkType.rightEyeInner],
        [PoseLandmarkType.rightEyeInner, PoseLandmarkType.rightEye],
        [PoseLandmarkType.rightEye, PoseLandmarkType.rightEyeOuter],
        [PoseLandmarkType.rightEyeOuter, PoseLandmarkType.rightEar],
        [PoseLandmarkType.mouthLeft, PoseLandmarkType.mouthRight],
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
        [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
        [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
        [PoseLandmarkType.rightWrist, PoseLandmarkType.rightElbow],
        [PoseLandmarkType.rightWrist, PoseLandmarkType.rightThumb],
        [PoseLandmarkType.rightWrist, PoseLandmarkType.rightIndexFinger],
        [PoseLandmarkType.rightWrist, PoseLandmarkType.rightPinkyFinger],
        [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],
        [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
        [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
        [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
        [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],
        [PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder],
        [PoseLandmarkType.leftWrist, PoseLandmarkType.leftElbow],
        [PoseLandmarkType.leftWrist, PoseLandmarkType.leftThumb],
        [PoseLandmarkType.leftWrist, PoseLandmarkType.leftIndexFinger],
        [PoseLandmarkType.leftWrist, PoseLandmarkType.leftPinkyFinger],
        [PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel],
        [PoseLandmarkType.leftAnkle, PoseLandmarkType.leftToe],
        [PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel],
        [PoseLandmarkType.rightAnkle, PoseLandmarkType.rightToe],
        [PoseLandmarkType.rightHeel, PoseLandmarkType.rightToe],
        [PoseLandmarkType.leftHeel, PoseLandmarkType.leftToe],
        [PoseLandmarkType.rightIndexFinger, PoseLandmarkType.rightPinkyFinger],
        [PoseLandmarkType.leftIndexFinger, PoseLandmarkType.leftPinkyFinger],
      ];
}
