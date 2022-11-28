import 'dart:ui' as ui;

//import 'package:FitnessApp/main.dart';
import 'package:flutter/widgets.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';

import 'package:body_detection/models/point3d.dart';
import 'dart:math';

import 'provider.dart' as globals;
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:pausable_timer/pausable_timer.dart';

class PoseMaskPainter extends CustomPainter {
  PoseMaskPainter({
    required this.pose,
    required this.mask,
    required this.imageSize,

  });

  final Pose? pose;
  final ui.Image? mask;
  final Size imageSize;
  final pointPaint = Paint()
    ..color = const Color.fromRGBO(255, 255, 255, 0.8);
  final leftPointPaint = Paint()
    ..color = const Color.fromRGBO(223, 157, 80, 1);
  final rightPointPaint = Paint()
    ..color = const Color.fromRGBO(100, 208, 218, 1);
  final linePaint = Paint()
    ..color = const Color.fromRGBO(255, 255, 255, 0.9)
    ..strokeWidth = 3;
  final wronglinePaint = Paint()
    ..color = const Color.fromRGBO(255, 0, 0, 0.9)
    ..strokeWidth = 3;
  final maskPaint = Paint()
    ..colorFilter = const ColorFilter.mode(
        Color.fromRGBO(0, 0, 255, 0.5), BlendMode.srcOut);
  //



  @override
  void paint(Canvas canvas, Size size) {

    _printPose(canvas, size);
    // _testTimer(canvas, size);
     // _squat(canvas, size);//深蹲
    // _legpullover(canvas, size);//自體腿部屈伸
    // _sidelegraise(canvas, size);//側臥抬腿
    // _kneelinglegraise(canvas, size);//跪姿抬腿
    // _pyramidStretch(canvas, size);//金字塔式拉伸
    // _lunge(canvas, size);//弓箭步
    _statedForwardBendStretch(canvas, size); //坐姿前彎伸展
  }

  @override
  bool shouldRepaint(PoseMaskPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        oldDelegate.mask != mask ||
        oldDelegate.imageSize != imageSize;
  }

  List<List<PoseLandmarkType>> get connections =>
      [[PoseLandmarkType.leftEar, PoseLandmarkType.leftEyeOuter],
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

  int calculate_angle(PoseLandmark partA, PoseLandmark partB, PoseLandmark partC) {
    // double angle = atan2(P3.y - P1.y, P3.x - P1.x) -
    //     atan2(P2.y - P1.y, P2.x - P1.x);
  int anglePartb = ((atan2(partC.position.y - partB.position.y,
      partC.position.x - partB.position.x) -
      atan2(partA.position.y - partB.position.y,
          partA.position.x - partB.position.x)) * 180 / pi).abs()
      .toInt()
      .round();
  if (anglePartb >= 180) {
    anglePartb = 360 - anglePartb;
  }
  return anglePartb;
    // print("Part B的角度 ：");
    // print(anglePartb);
    // If you mean the angle that P1 is the vertex of then using the Law of Cosines should work:
    //
    // arccos((P122 + P132 - P232) / (2 * P12 * P13))
    //
    // where P12 is the length of the segment from P1 to P2, calculated by
    //
    // sqrt((P1x - P2x)2 + (P1y - P2y)2)
    // print("partA的動作名稱 : ");
    // print(partA.type.toString());
    // print("partA的x, y座標 : ");
    // print(Offset(partA.position.x, partA.position.y).dx.toString() + " , " + Offset(partA.position.x, partA.position.y).dy.toString());
    // print("partB的動作名稱 : ");
    // print(partB.type.toString());
    // print("partB的x, y座標 : ");
    // print(Offset(partB.position.x, partB.position.y).dx.toString() + " , " + Offset(partB.position.x, partB.position.y).dy.toString());
    // print("partC的動作名稱 : ");
    // print(partC.type.toString());
    // print("partC的x, y座標 : ");
    // print(Offset(partC.position.x, partC.position.y).dx.toString() + " , " + Offset(partC.position.x, partC.position.y).dy.toString());
  }
//姿勢繪圖---------------------------------------------------------------------------------------------------
  void _printPose(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio = imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio = imageSize.height == 0 ? 1 : size.height / imageSize.height;
    offsetForPart(PoseLandmark part) => Offset(part.position.x * hRatio, part.position.y * vRatio);

    //畫線
    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};
    //print("landmarksByType : " + landmarksByType.toString()); // landmarksByType : {PoseLandmarkType.nose: Instance of 'PoseLandmark', P
    for (final connection in connections) {
      final point1 = offsetForPart(landmarksByType[connection[0]]!);
      // print("point1 : " + point1.toString());
      final point2 = offsetForPart(landmarksByType[connection[1]]!);
      // print("point2 : " + point2.toString());
      canvas.drawLine(point1, point2, linePaint);
    }

    //畫點
    for (final part in pose!.landmarks) {
      // Landmark points
      canvas.drawCircle(offsetForPart(part), 5, pointPaint);
      if (part.type.isLeftSide) {
        canvas.drawCircle(offsetForPart(part), 3, leftPointPaint);
      } else if (part.type.isRightSide) {
        canvas.drawCircle(offsetForPart(part), 3, rightPointPaint);
      }

    // //部位標示
    // TextSpan span = TextSpan(
    //   text: part.type.toString().substring(16),
    //   style: const TextStyle(
    //     color: Color.fromRGBO(0, 128, 255, 1),
    //     fontSize: 25,
    //     shadows: [
    //       ui.Shadow(
    //         color: Color.fromRGBO(255, 255, 255, 1),
    //         offset: Offset(1, 1),
    //         blurRadius: 1,
    //       ),
    //     ],
    //   ),
    // );
    // TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left);
    // tp.textDirection = TextDirection.ltr;
    // tp.layout();
    // tp.paint(canvas, offsetForPart(part).translate(0, -20));
    }
  }

  //深蹲---------------------------------------------------------------------------------------------------
  void _squat(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio = imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio = imageSize.height == 0 ? 1 : size.height / imageSize.height;
    offsetForPart(PoseLandmark part) => Offset(part.position.x * hRatio, part.position.y * vRatio);

    late PoseLandmark rightHip;
    late PoseLandmark rightKnee;
    late PoseLandmark rightAnkle;
    late PoseLandmark leftHip;
    late PoseLandmark leftKnee;
    late PoseLandmark leftAnkle;

    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};
    rightHip = landmarksByType[PoseLandmarkTypeExtension.fromId(23)]!;
    rightKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(25)]!;
    rightAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(27)]!;
    leftHip = landmarksByType[PoseLandmarkTypeExtension.fromId(24)]!;
    leftKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(26)]!;
    leftAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(28)]!;

    //查看是否將攝影機擺正，盡量去避免辨識錯誤可能性
    print(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y);
    if(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y > 600){
      print("請將攝影機調整以照到全身");
      return;
    }
    int rightKneeAngle = calculate_angle(rightHip, rightKnee, rightAnkle);
    int leftKneeAngle = calculate_angle(leftHip, leftKnee, leftAnkle);

    //測試用看角度
    TextSpan rightKneeAngleText = TextSpan(
      text:rightKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp = TextPainter(text: rightKneeAngleText, textAlign: TextAlign.left);
    tp.textDirection = TextDirection.ltr;
    tp.layout();
    tp.paint(canvas, offsetForPart(rightKnee));
    //測試用看角度
    TextSpan leftKneeAngleText = TextSpan(
      text:leftKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    tp = TextPainter(text: leftKneeAngleText, textAlign: TextAlign.left);
    tp.textDirection = TextDirection.ltr;
    tp.layout();
    tp.paint(canvas, offsetForPart(leftKnee));

    if(rightKneeAngle > 160 && leftKneeAngle > 160 && globals.Provider.squatLock == false){
      globals.Provider.state = "down";
      globals.Provider.squatLock = true;
      if(globals.Provider.firstLock == false) {
        globals.Provider.counter += 1;
      }

    }else if(rightKneeAngle < 80 && leftKneeAngle < 80 && globals.Provider.squatLock == true){
      globals.Provider.state = "up";
      globals.Provider.squatLock = false;
      if(globals.Provider.firstLock == true){
        globals.Provider.firstLock = false;
      }
    }
    if(globals.Provider.counter >= 5){
      globals.Provider.sidelegraiseState = "Done";
    }
  }

//自體腿部屈伸------------------------------------------------------------------------------------------------------
  void _legpullover(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio =
    imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
    imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

    late PoseLandmark rightHip;
    late PoseLandmark rightKnee;
    late PoseLandmark rightAnkle;
    late PoseLandmark leftHip;
    late PoseLandmark leftKnee;
    late PoseLandmark leftAnkle;
    late PoseLandmark rightShoulder;
    late PoseLandmark leftShoulder;
    late PoseLandmark rightElbow;
    late PoseLandmark leftElbow;

    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};

    rightHip = landmarksByType[PoseLandmarkTypeExtension.fromId(23)]!;
    rightKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(25)]!;
    rightAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(27)]!;
    leftHip = landmarksByType[PoseLandmarkTypeExtension.fromId(24)]!;
    leftKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(26)]!;
    leftAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(28)]!;
    rightShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(11)]!;
    leftShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(12)]!;
    rightElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(13)]!;
    leftElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(14)]!;

    //查看是否將攝影機擺正，盡量去避免辨識錯誤可能性
    print(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y);
    if(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y > 600){
      print("請將攝影機調整以照到全身");
      return;
    }
    int rightKneeAngle = calculate_angle(rightHip, rightKnee, rightAnkle);
    int leftKneeAngle = calculate_angle(leftHip, leftKnee, leftAnkle);
    int rightHipAngle = calculate_angle(rightShoulder, rightHip, rightKnee);
    int leftHipAngle = calculate_angle(leftShoulder, leftHip, leftKnee);
    int rightShoulderAngle = calculate_angle(rightElbow, rightShoulder, rightHip);
    int leftShoulderAngle = calculate_angle(leftElbow, leftShoulder, leftHip);

    //測試用看角度
    TextSpan rightKneeAngleText = TextSpan(
      text:rightKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp = TextPainter(text: rightKneeAngleText, textAlign: TextAlign.left);
    tp.textDirection = TextDirection.ltr;
    tp.layout();
    tp.paint(canvas, offsetForPart(rightKnee));

    //測試用看角度
    TextSpan leftKneeAngleText = TextSpan(
      text:leftKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp1 = TextPainter(text: leftKneeAngleText, textAlign: TextAlign.left);
    tp1.textDirection = TextDirection.ltr;
    tp1.layout();
    tp1.paint(canvas, offsetForPart(leftKnee));

    //測試用看角度
    TextSpan rightHipAngleText = TextSpan(
      text: rightHipAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp2 = TextPainter(text: rightHipAngleText, textAlign: TextAlign.left);
    tp2.textDirection = TextDirection.ltr;
    tp2.layout();
    tp2.paint(canvas, offsetForPart(rightHip));

    //測試用看角度
    TextSpan leftHipAngleText = TextSpan(
      text: leftHipAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp3 = TextPainter(text: leftHipAngleText, textAlign: TextAlign.left);
    tp3.textDirection = TextDirection.ltr;
    tp3.layout();
    tp3.paint(canvas, offsetForPart(leftHip));

    //測試用看角度
    TextSpan rightShoulderAngleText = TextSpan(
      text: rightShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp5 = TextPainter(text: rightShoulderAngleText, textAlign: TextAlign.left);
    tp5.textDirection = TextDirection.ltr;
    tp5.layout();
    tp5.paint(canvas, offsetForPart(rightShoulder));

    //測試用看角度
    TextSpan leftShoulderAngleText = TextSpan(
      text: leftShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp6 = TextPainter(text: leftShoulderAngleText, textAlign: TextAlign.left);
    tp6.textDirection = TextDirection.ltr;
    tp6.layout();
    tp6.paint(canvas, offsetForPart(leftShoulder));

    print("the counter is : " + globals.Provider.counter.toString());
    if( rightKneeAngle > 70  && leftKneeAngle  > 70  && rightHipAngle > 150 && leftHipAngle  > 150 && rightShoulderAngle < 30
        && leftShoulderAngle < 30 && globals.Provider.legpulloverLock == false){
      globals.Provider.state = "down";
      globals.Provider.legpulloverLock = true;
      if(globals.Provider.firstLock == false) {
        globals.Provider.counter += 1;
      }
      print("the counter is : " + globals.Provider.counter.toString());
    }else if(rightKneeAngle < 55  && leftKneeAngle < 55  && rightHipAngle > 150 && leftHipAngle > 150 && rightShoulderAngle < 30
        && leftShoulderAngle < 30 && globals.Provider.legpulloverLock == true){
      globals.Provider.state = "up";
      globals.Provider.legpulloverLock = false;
      if(globals.Provider.firstLock == true){
        globals.Provider.firstLock = false;
      }
    }
  }

  //側臥抬腿------------------------------------------------------------------------------------------------------
  void _sidelegraise(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio =
    imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
    imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);


    late PoseLandmark rightHip;
    late PoseLandmark rightKnee;
    late PoseLandmark rightAnkle;
    late PoseLandmark leftHip;
    late PoseLandmark leftKnee;
    late PoseLandmark leftAnkle;
    late PoseLandmark rightShoulder;
    late PoseLandmark leftShoulder;
    late PoseLandmark rightElbow;
    late PoseLandmark leftElbow;

    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};

    //查看是否將攝影機擺正，盡量去避免辨識錯誤可能性
    print(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y);
    if(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y > 600){
      print("請將攝影機調整以照到全身");
      return;
    }

    rightHip = landmarksByType[PoseLandmarkTypeExtension.fromId(23)]!;
    rightKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(25)]!;
    rightAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(27)]!;
    leftHip = landmarksByType[PoseLandmarkTypeExtension.fromId(24)]!;
    leftKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(26)]!;
    leftAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(28)]!;
    rightShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(11)]!;
    leftShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(12)]!;
    rightElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(13)]!;
    leftElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(14)]!;

    int rightHipAngle = calculate_angle(rightKnee, rightHip, leftKnee);
    int leftHipAngle  = calculate_angle(leftKnee,  leftHip,  rightKnee);
    int rightKneeAngle = calculate_angle(rightHip, rightKnee, rightAnkle);
    int leftKneeAngle = calculate_angle(leftHip, leftKnee, leftAnkle);
    int rightShoulderAngle = calculate_angle(rightElbow, rightShoulder, rightHip);
    int leftShoulderAngle = calculate_angle(leftElbow, leftShoulder, leftHip);

    //測試用看角度
    TextSpan rightHipAngleText = TextSpan(
      text: rightHipAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp1 = TextPainter(text: rightHipAngleText, textAlign: TextAlign.left);
    tp1.textDirection = TextDirection.ltr;
    tp1.layout();
    tp1.paint(canvas, offsetForPart(rightHip));

    //測試用看角度
    TextSpan leftHipAngleText = TextSpan(
      text: leftHipAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp2 = TextPainter(text: leftHipAngleText, textAlign: TextAlign.left);
    tp2.textDirection = TextDirection.ltr;
    tp2.layout();
    tp2.paint(canvas, offsetForPart(leftHip));

    //測試用看角度
    TextSpan leftKneeAngleText = TextSpan(
      text: leftKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp3 = TextPainter(text: leftKneeAngleText, textAlign: TextAlign.left);
    tp3.textDirection = TextDirection.ltr;
    tp3.layout();
    tp3.paint(canvas, offsetForPart(leftKnee));

    //測試用看角度
    TextSpan rightKneeAngleText = TextSpan(
      text: rightKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp4 = TextPainter(text: rightKneeAngleText, textAlign: TextAlign.left);
    tp4.textDirection = TextDirection.ltr;
    tp4.layout();
    tp4.paint(canvas, offsetForPart(rightKnee));

    //測試用看角度
    TextSpan rightShoulderAngleText = TextSpan(
      text: rightShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp5 = TextPainter(text: rightShoulderAngleText, textAlign: TextAlign.left);
    tp5.textDirection = TextDirection.ltr;
    tp5.layout();
    tp5.paint(canvas, offsetForPart(rightShoulder));

    //測試用看角度
    TextSpan leftShoulderAngleText = TextSpan(
      text: leftShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp6 = TextPainter(text: leftShoulderAngleText, textAlign: TextAlign.left);
    tp6.textDirection = TextDirection.ltr;
    tp6.layout();
    tp6.paint(canvas, offsetForPart(leftShoulder));

    if(globals.Provider.sidelegraiseState == ""){
      globals.Provider.sidelegraiseState = "left";
      globals.Provider.state = "up";
    }else if(globals.Provider.sidelegraiseState == "left"){
      if(leftHipAngle > 70 && leftShoulderAngle > 40 && rightKneeAngle > 150 && leftKneeAngle > 150 && globals.Provider.sidelegLock == false){
        globals.Provider.state = "down";
        globals.Provider.sidelegLock = true;
      }else if(leftHipAngle < 25 && leftShoulderAngle > 40 && rightKneeAngle > 150 && leftKneeAngle > 150 && globals.Provider.sidelegLock == true){
        globals.Provider.state = "up";
        globals.Provider.sidelegLock = false;
        globals.Provider.counter += 1;
        if(globals.Provider.counter >= 5){
          globals.Provider.sidelegraiseState = "right";
          globals.Provider.counter = 0;
        }
      }
    }else if(globals.Provider.sidelegraiseState == "right"){
      if(rightHipAngle > 70 && rightShoulderAngle > 40 && rightKneeAngle > 150 && leftKneeAngle > 150 && globals.Provider.sidelegLock == false){
        globals.Provider.state = "down";
        globals.Provider.sidelegLock = true;
      }else if(rightHipAngle < 25 && rightShoulderAngle > 40 && rightKneeAngle > 150 && leftKneeAngle > 150 && globals.Provider.sidelegLock == true){
        globals.Provider.state = "up";
        globals.Provider.sidelegLock = false;
        globals.Provider.counter += 1;
        if(globals.Provider.counter >= 5){
          globals.Provider.sidelegraiseState = "Done";
          globals.Provider.counter = 0;
        }
      }
    }
  }

  // //跪姿抬腿------------------------------------------------------------------------------------------------------
  void _kneelinglegraise(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio =
    imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
    imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

    late PoseLandmark rightHip;
    late PoseLandmark rightKnee;
    late PoseLandmark rightAnkle;
    late PoseLandmark leftHip;
    late PoseLandmark leftKnee;
    late PoseLandmark leftAnkle;
    late PoseLandmark rightShoulder;
    late PoseLandmark leftShoulder;

    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};

    //查看是否將攝影機擺正，盡量去避免辨識錯誤可能性
    print(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y);
    if(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y > 600){
      print("請將攝影機調整以照到全身");
      return;
    }

    rightHip = landmarksByType[PoseLandmarkTypeExtension.fromId(23)]!;
    rightKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(25)]!;
    rightAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(27)]!;
    leftHip = landmarksByType[PoseLandmarkTypeExtension.fromId(24)]!;
    leftKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(26)]!;
    leftAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(28)]!;
    rightShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(11)]!;
    leftShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(12)]!;

    int rightHipAngle = calculate_angle(rightKnee, rightHip, leftKnee);
    int leftHipAngle  = calculate_angle(leftKnee,  leftHip,  rightKnee);
    int rightKneeAngle = calculate_angle(rightHip, rightKnee, rightAnkle);
    int leftKneeAngle = calculate_angle(leftHip, leftKnee, leftAnkle);


    //測試用看角度
    TextSpan rightHipAngleText = TextSpan(
      text: rightHipAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp1 = TextPainter(text: rightHipAngleText, textAlign: TextAlign.left);
    tp1.textDirection = TextDirection.ltr;
    tp1.layout();
    tp1.paint(canvas, offsetForPart(rightHip));

    //測試用看角度
    TextSpan leftHipAngleText = TextSpan(
      text: leftHipAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp2 = TextPainter(text: leftHipAngleText, textAlign: TextAlign.left);
    tp2.textDirection = TextDirection.ltr;
    tp2.layout();
    tp2.paint(canvas, offsetForPart(leftHip));

    //測試用看角度
    TextSpan rightKneeAngleText = TextSpan(
      text: rightKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp3 = TextPainter(text: rightKneeAngleText, textAlign: TextAlign.left);
    tp3.textDirection = TextDirection.ltr;
    tp3.layout();
    tp3.paint(canvas, offsetForPart(rightKnee));

    //測試用看角度
    TextSpan leftKneeAngleText = TextSpan(
      text: leftKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp4 = TextPainter(text: leftKneeAngleText, textAlign: TextAlign.left);
    tp4.textDirection = TextDirection.ltr;
    tp4.layout();
    tp4.paint(canvas, offsetForPart(leftKnee));

    //動作角度判別計數
    if(globals.Provider.kneelinglegraise == ""){
      globals.Provider.kneelinglegraise = "left";
      globals.Provider.state = "up";
    }else if(globals.Provider.kneelinglegraise == "left"){ //抬左腿
      if(rightKneeAngle > 40 && rightKneeAngle < 100 && rightHipAngle > 80 && leftKneeAngle > 140 && globals.Provider.sidelegLock == false){
        globals.Provider.state = "down";
        globals.Provider.sidelegLock = true;
      }else if(rightKneeAngle > 40 && rightKneeAngle < 100 && rightHipAngle < 30 && leftKneeAngle < 80 && globals.Provider.sidelegLock == true){
        globals.Provider.state = "up";
        globals.Provider.sidelegLock = false;
        globals.Provider.counter += 1;
        if(globals.Provider.counter >= 10){
          globals.Provider.kneelinglegraise = "right";
          globals.Provider.counter = 0;
        }
      }
    }else if(globals.Provider.kneelinglegraise == "right"){//抬右腿
      if(leftKneeAngle > 40 && leftKneeAngle < 100 && leftHipAngle > 80 && rightKneeAngle > 140 && globals.Provider.sidelegLock == false){
        globals.Provider.state = "down";
        globals.Provider.sidelegLock = true;
      }else if(leftKneeAngle > 40 && leftKneeAngle < 100 && leftHipAngle < 30 && rightKneeAngle < 80 && globals.Provider.sidelegLock == true){
        globals.Provider.state = "up";
        globals.Provider.sidelegLock = false;
        globals.Provider.counter += 1;
        if(globals.Provider.counter >= 10){
          globals.Provider.kneelinglegraise = "Done";
          globals.Provider.counter = 0;
        }
      }
    }
  }
  // //金字塔式拉伸------------------------------------------------------------------------------------------------------
  static final timer = PausableTimer(Duration(seconds: 10), () => print('Timer created!'));
  static final timer1 = PausableTimer(Duration(seconds: 10), () => print('Timer1 created!'));
  static final timer2 = PausableTimer(Duration(seconds: 5), () => print('Timer2 created!'));

  void _pyramidStretch(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio =
    imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
    imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

    late PoseLandmark rightHip;
    late PoseLandmark rightKnee;
    late PoseLandmark rightAnkle;
    late PoseLandmark leftHip;
    late PoseLandmark leftKnee;
    late PoseLandmark leftAnkle;
    late PoseLandmark rightShoulder;
    late PoseLandmark leftShoulder;
    late PoseLandmark rightElbow;
    late PoseLandmark leftElbow;

    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};

    //查看是否將攝影機擺正，盡量去避免辨識錯誤可能性
    print(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y);
    if(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y- landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y > 600){
      print("請將攝影機調整以照到全身");
      return;
    }

    rightHip = landmarksByType[PoseLandmarkTypeExtension.fromId(23)]!;
    rightKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(25)]!;
    rightAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(27)]!;
    leftHip = landmarksByType[PoseLandmarkTypeExtension.fromId(24)]!;
    leftKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(26)]!;
    leftAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(28)]!;
    rightShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(11)]!;
    leftShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(12)]!;
    rightElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(13)]!;
    leftElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(14)]!;

    int rightHipAngle_1 = calculate_angle(rightKnee, rightHip, leftKnee);
    int leftHipAngle_1  = calculate_angle(leftKnee,  leftHip,  rightKnee);
    int rightHipAngle_2 = calculate_angle(rightKnee, rightHip, rightShoulder);
    int leftHipAngle_2  = calculate_angle(leftKnee,  leftHip,  leftShoulder);
    int rightShoulderAngle = calculate_angle(rightElbow, rightShoulder, rightHip);
    int leftShoulderAngle = calculate_angle(leftElbow, leftShoulder, leftHip);
    int rightKneeAngle  = calculate_angle(rightHip, rightKnee, rightAnkle);
    int leftKneeAngle = calculate_angle(leftHip, leftKnee, leftAnkle);


    //測試用看角度
    TextSpan rightHipAngleText_1 = TextSpan(
      text: rightHipAngle_1.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp1 = TextPainter(text: rightHipAngleText_1, textAlign: TextAlign.left);
    tp1.textDirection = TextDirection.ltr;
    tp1.layout();
    tp1.paint(canvas, offsetForPart(rightHip));

    //測試用看角度
    TextSpan leftHipAngleText_1 = TextSpan(
      text: leftHipAngle_1.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp2 = TextPainter(text: leftHipAngleText_1, textAlign: TextAlign.left);
    tp2.textDirection = TextDirection.ltr;
    tp2.layout();
    tp2.paint(canvas, offsetForPart(leftHip));

    //測試用看角度
    TextSpan rightHipAngleText_2 = TextSpan(
      text: rightHipAngle_2.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp3 = TextPainter(text: rightHipAngleText_2, textAlign: TextAlign.left);
    tp3.textDirection = TextDirection.ltr;
    tp3.layout();
    tp3.paint(canvas, Offset(rightHip.position.x * hRatio, rightHip.position.y-20 * vRatio));


    //測試用看角度
    TextSpan leftHipAngleText_2 = TextSpan(
      text: leftHipAngle_2.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp4 = TextPainter(text: leftHipAngleText_2, textAlign: TextAlign.left);
    tp4.textDirection = TextDirection.ltr;
    tp4.layout();
    tp4.paint(canvas, Offset(leftHip.position.x * hRatio, leftHip.position.y-20 * vRatio));

    //測試用看角度
    TextSpan rightShoulderAngleText = TextSpan(
      text: rightShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp5 = TextPainter(text: rightShoulderAngleText, textAlign: TextAlign.left);
    tp5.textDirection = TextDirection.ltr;
    tp5.layout();
    tp5.paint(canvas, offsetForPart(rightShoulder));

    //測試用看角度
    TextSpan leftShoulderAngleText = TextSpan(
      text: leftShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp6 = TextPainter(text: leftShoulderAngleText, textAlign: TextAlign.left);
    tp6.textDirection = TextDirection.ltr;
    tp6.layout();
    tp6.paint(canvas, offsetForPart(leftShoulder));

    //測試用看角度
    TextSpan rightKneeAngleText = TextSpan(
      text: rightKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp7 = TextPainter(text: rightKneeAngleText, textAlign: TextAlign.left);
    tp7.textDirection = TextDirection.ltr;
    tp7.layout();
    tp7.paint(canvas, offsetForPart(rightKnee));

    //測試用看角度
    TextSpan leftKneeAngleText = TextSpan(
      text: leftKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp8 = TextPainter(text: leftKneeAngleText, textAlign: TextAlign.left);
    tp8.textDirection = TextDirection.ltr;
    tp8.layout();
    tp8.paint(canvas, offsetForPart(leftKnee));

    globals.Provider.timer = timer.elapsed.inSeconds;
      if(globals.Provider.pyramidStretchState == ""){
        globals.Provider.pyramidStretchState = "left";
        globals.Provider.state = "down";
      }else if(globals.Provider.pyramidStretchState == "left"){
        if(leftHipAngle_1 > 50 && leftHipAngle_2 > 50 && leftShoulderAngle > 50 && rightKneeAngle > 150 &&
            leftKneeAngle > 150 ){
          timer.start();
          globals.Provider.CounterOrTimer = "Timer";
          if(timer.elapsed.inSeconds >= 5){
            globals.Provider.pyramidStretchState = "right";
            timer.reset();
          }
        }else{
          timer.pause();
        }
      }else if(globals.Provider.pyramidStretchState == "right"){
        if(rightHipAngle_1 > 50 && rightHipAngle_2 > 50 && rightShoulderAngle > 50 && rightKneeAngle > 150 &&
            leftKneeAngle > 150){
          globals.Provider.state = "down";
          timer.start();
          if(timer.elapsed.inSeconds >= 5){
            timer.pause();
            timer.reset();
            globals.Provider.pyramidStretchState = "Done";
          }
        }else{
          timer.pause();
        }
      }
    }

  //弓箭步------------------------------------------------------------------------------------------------------
  void _lunge(Canvas canvas, Size size) { //弓箭步
    if (pose == null) return;

    final double hRatio =
    imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
    imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

    late PoseLandmark rightHip;
    late PoseLandmark rightKnee;
    late PoseLandmark rightAnkle;
    late PoseLandmark leftHip;
    late PoseLandmark leftKnee;
    late PoseLandmark leftAnkle;
    late PoseLandmark rightShoulder;
    late PoseLandmark leftShoulder;
    late PoseLandmark rightElbow;
    late PoseLandmark leftElbow;

    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};

    //查看是否將攝影機擺正，盡量去避免辨識錯誤可能性
    print(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y -
        landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y);
    if (landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y -
        landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y >
        600) {
      globals.Provider.state = "outOfRange";
      return;
    }else{

    }

    rightHip = landmarksByType[PoseLandmarkTypeExtension.fromId(23)]!;
    rightKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(25)]!;
    rightAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(27)]!;
    leftHip = landmarksByType[PoseLandmarkTypeExtension.fromId(24)]!;
    leftKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(26)]!;
    leftAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(28)]!;
    rightShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(11)]!;
    leftShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(12)]!;
    rightElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(13)]!;
    leftElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(14)]!;

    int rightHipAngle_1 = calculate_angle(rightKnee, rightHip, leftKnee);
    int leftHipAngle_1 = calculate_angle(leftKnee, leftHip, rightKnee);
    int rightHipAngle_2 = calculate_angle(rightKnee, rightHip, rightShoulder);
    int leftHipAngle_2 = calculate_angle(leftKnee, leftHip, leftShoulder);
    int rightShoulderAngle = calculate_angle(rightElbow, rightShoulder, rightHip);
    int leftShoulderAngle = calculate_angle(leftElbow, leftShoulder, leftHip);
    int rightKneeAngle = calculate_angle(rightHip, rightKnee, rightAnkle);
    int leftKneeAngle = calculate_angle(leftHip, leftKnee, leftAnkle);

    //測試用看角度
    TextSpan rightHipAngleText_1 = TextSpan(
      text: rightHipAngle_1.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp1 = TextPainter(text: rightHipAngleText_1, textAlign: TextAlign.left);
    tp1.textDirection = TextDirection.ltr;
    tp1.layout();
    tp1.paint(canvas, offsetForPart(rightHip));

    //測試用看角度
    TextSpan leftHipAngleText_1 = TextSpan(
      text: leftHipAngle_1.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp2 = TextPainter(text: leftHipAngleText_1, textAlign: TextAlign.left);
    tp2.textDirection = TextDirection.ltr;
    tp2.layout();
    tp2.paint(canvas, offsetForPart(leftHip));

    //測試用看角度
    TextSpan rightHipAngleText_2 = TextSpan(
      text: rightHipAngle_2.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp3 = TextPainter(text: rightHipAngleText_2, textAlign: TextAlign.left);
    tp3.textDirection = TextDirection.ltr;
    tp3.layout();
    tp3.paint(canvas, Offset(rightHip.position.x * hRatio, rightHip.position.y-20 * vRatio));


    //測試用看角度
    TextSpan leftHipAngleText_2 = TextSpan(
      text: leftHipAngle_2.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp4 = TextPainter(text: leftHipAngleText_2, textAlign: TextAlign.left);
    tp4.textDirection = TextDirection.ltr;
    tp4.layout();
    tp4.paint(canvas, Offset(leftHip.position.x * hRatio, leftHip.position.y-20 * vRatio));

    //測試用看角度
    TextSpan rightShoulderAngleText = TextSpan(
      text: rightShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp5 = TextPainter(text: rightShoulderAngleText, textAlign: TextAlign.left);
    tp5.textDirection = TextDirection.ltr;
    tp5.layout();
    tp5.paint(canvas, offsetForPart(rightShoulder));

    //測試用看角度
    TextSpan leftShoulderAngleText = TextSpan(
      text: leftShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp6 = TextPainter(text: leftShoulderAngleText, textAlign: TextAlign.left);
    tp6.textDirection = TextDirection.ltr;
    tp6.layout();
    tp6.paint(canvas, offsetForPart(leftShoulder));

    //測試用看角度
    TextSpan rightKneeAngleText = TextSpan(
      text: rightKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp7 = TextPainter(text: rightKneeAngleText, textAlign: TextAlign.left);
    tp7.textDirection = TextDirection.ltr;
    tp7.layout();
    tp7.paint(canvas, offsetForPart(rightKnee));

    //測試用看角度
    TextSpan leftKneeAngleText = TextSpan(
      text: leftKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp8 = TextPainter(text: leftKneeAngleText, textAlign: TextAlign.left);
    tp8.textDirection = TextDirection.ltr;
    tp8.layout();
    tp8.paint(canvas, offsetForPart(leftKnee));

    globals.Provider.timer = timer1.elapsed.inSeconds;
    if(globals.Provider.lungeState == ""){
      globals.Provider.lungeState = "left";
    }else if(globals.Provider.lungeState == "left"){
      globals.Provider.state = "down";
      globals.Provider.CounterOrTimer = "Timer";
      if(leftHipAngle_1 > 50 && leftHipAngle_2 > 80 && leftKneeAngle > 50 && leftKneeAngle < 135 && rightKneeAngle > 140){
        timer1.start();
        if(timer1.elapsed.inSeconds >= 5){
          globals.Provider.lungeState = "right";
          timer1.reset();
        }
      }else{
        timer1.pause();
      }
    }else if(globals.Provider.lungeState == "right"){
      if(rightHipAngle_1 > 50 && rightHipAngle_2 > 80 && rightKneeAngle > 50 && rightKneeAngle < 135 && leftKneeAngle > 140){
        globals.Provider.state = "down";
        timer1.start();
        if(timer1.elapsed.inSeconds >= 5){
          timer1.pause();
          timer1.reset();
          globals.Provider.lungeState = "Done";
        }
      }else{
        timer1.pause();
      }
    }
  }

  //坐姿前彎伸展------------------------------------------------------------------------------------------------------
  void _statedForwardBendStretch(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio =
    imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
    imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

    late PoseLandmark rightHip;
    late PoseLandmark rightKnee;
    late PoseLandmark rightAnkle;
    late PoseLandmark leftHip;
    late PoseLandmark leftKnee;
    late PoseLandmark leftAnkle;
    late PoseLandmark rightShoulder;
    late PoseLandmark leftShoulder;
    late PoseLandmark rightElbow;
    late PoseLandmark leftElbow;
    late PoseLandmark rightWrist;
    late PoseLandmark leftWrist;

    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};

    //查看是否將攝影機擺正，盡量去避免辨識錯誤可能性
    print(landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y -
        landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y);
    if (landmarksByType[PoseLandmarkTypeExtension.fromId(30)]!.position.y -
        landmarksByType[PoseLandmarkTypeExtension.fromId(0)]!.position.y >
        600) {
      globals.Provider.state = "outOfRange";
      return;
    }

    rightHip = landmarksByType[PoseLandmarkTypeExtension.fromId(23)]!;
    rightKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(25)]!;
    rightAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(27)]!;
    leftHip = landmarksByType[PoseLandmarkTypeExtension.fromId(24)]!;
    leftKnee = landmarksByType[PoseLandmarkTypeExtension.fromId(26)]!;
    leftAnkle = landmarksByType[PoseLandmarkTypeExtension.fromId(28)]!;
    rightShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(11)]!;
    leftShoulder = landmarksByType[PoseLandmarkTypeExtension.fromId(12)]!;
    rightElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(13)]!;
    leftElbow = landmarksByType[PoseLandmarkTypeExtension.fromId(14)]!;
    rightWrist = landmarksByType[PoseLandmarkTypeExtension.fromId(15)]!;
    leftWrist  = landmarksByType[PoseLandmarkTypeExtension.fromId(16)]!;

    int rightHipAngle_1 = calculate_angle(rightKnee, rightHip, leftKnee);
    int leftHipAngle_1 = calculate_angle(leftKnee, leftHip, rightKnee);
    int rightKneeHipElbowAngle = calculate_angle(rightKnee, rightHip, rightElbow);
    int leftKneeHipElbowAngle = calculate_angle(leftKnee, leftHip, leftElbow);
    int rightShoulderAngle = calculate_angle(rightElbow, rightShoulder, rightHip);
    int leftShoulderAngle = calculate_angle(leftElbow, leftShoulder, leftHip);
    int rightKneeAngle = calculate_angle(rightHip, rightKnee, rightAnkle);
    int leftKneeAngle = calculate_angle(leftHip, leftKnee, leftAnkle);
    int rightElbowAngle = calculate_angle(rightShoulder, rightElbow, rightWrist);
    int leftElbowAngle = calculate_angle(leftShoulder, leftElbow, leftWrist);

    //測試用看角度
    TextSpan rightHipAngleText_1 = TextSpan(
      text: rightHipAngle_1.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp1 = TextPainter(text: rightHipAngleText_1, textAlign: TextAlign.left);
    tp1.textDirection = TextDirection.ltr;
    tp1.layout();
    tp1.paint(canvas, offsetForPart(rightHip));

    //測試用看角度
    TextSpan leftHipAngleText_1 = TextSpan(
      text: leftHipAngle_1.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp2 = TextPainter(text: leftHipAngleText_1, textAlign: TextAlign.left);
    tp2.textDirection = TextDirection.ltr;
    tp2.layout();
    tp2.paint(canvas, offsetForPart(leftHip));

    //測試用看角度
    TextSpan rightHipAngleText_2 = TextSpan(
      text: rightKneeHipElbowAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp3 = TextPainter(text: rightHipAngleText_2, textAlign: TextAlign.left);
    tp3.textDirection = TextDirection.ltr;
    tp3.layout();
    tp3.paint(canvas, Offset(rightHip.position.x * hRatio - 40, rightHip.position.y * vRatio - 40));


    //測試用看角度
    TextSpan leftHipAngleText_2 = TextSpan(
      text: leftKneeHipElbowAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp4 = TextPainter(text: leftHipAngleText_2, textAlign: TextAlign.left);
    tp4.textDirection = TextDirection.ltr;
    tp4.layout();
    tp4.paint(canvas, Offset(leftHip.position.x * hRatio - 40, leftHip.position.y * vRatio - 40));

    //測試用看角度
    TextSpan rightShoulderAngleText = TextSpan(
      text: rightShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp5 = TextPainter(text: rightShoulderAngleText, textAlign: TextAlign.left);
    tp5.textDirection = TextDirection.ltr;
    tp5.layout();
    tp5.paint(canvas, offsetForPart(rightShoulder));

    //測試用看角度
    TextSpan leftShoulderAngleText = TextSpan(
      text: leftShoulderAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp6 = TextPainter(text: leftShoulderAngleText, textAlign: TextAlign.left);
    tp6.textDirection = TextDirection.ltr;
    tp6.layout();
    tp6.paint(canvas, offsetForPart(leftShoulder));

    //測試用看角度
    TextSpan rightKneeAngleText = TextSpan(
      text: rightKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp7 = TextPainter(text: rightKneeAngleText, textAlign: TextAlign.left);
    tp7.textDirection = TextDirection.ltr;
    tp7.layout();
    tp7.paint(canvas, offsetForPart(rightKnee));

    //測試用看角度
    TextSpan leftKneeAngleText = TextSpan(
      text: leftKneeAngle.toString(),
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 25,
      ),
    );
    TextPainter tp8 = TextPainter(text: leftKneeAngleText, textAlign: TextAlign.left);
    tp8.textDirection = TextDirection.ltr;
    tp8.layout();
    tp8.paint(canvas, offsetForPart(leftKnee));

    globals.Provider.timer = timer2.elapsed.inSeconds;
    if(globals.Provider.statedForwardBendStretchState == ""){
      globals.Provider.statedForwardBendStretchState = "left";
    }else if(globals.Provider.statedForwardBendStretchState == "left"){
      globals.Provider.state = "down";
      globals.Provider.CounterOrTimer = "Timer";
      if(leftHipAngle_1 > 50 && leftKneeHipElbowAngle < 60 && leftKneeAngle > 150 && rightKneeAngle < 90 && leftShoulderAngle < 90 && leftElbowAngle > 130){
        timer2.start();
        if(timer2.isExpired == true){  // 可以用iselapsed()
          globals.Provider.statedForwardBendStretchState = "right";
          timer2.reset();
        }
      }else{
        timer2.pause();
      }
    }else if(globals.Provider.statedForwardBendStretchState == "right"){
      if(rightHipAngle_1 > 50 && rightKneeHipElbowAngle < 60 && rightKneeAngle > 150 && leftKneeAngle < 90 && rightShoulderAngle < 90 && rightElbowAngle > 130){
        globals.Provider.state = "down";
        timer2.start();
        if(timer2.isExpired == true){
          timer2.pause();
          timer2.reset();
          globals.Provider.statedForwardBendStretchState = "Done";
        }
      }else{
        timer2.pause();
      }
    }
  }
}



