import 'dart:math';

import 'package:body_detection_example/Exercising/detection/verify.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'dart:ui' as ui;

void main() {
  runApp(const TestMyApp());
}

class TestMyApp extends StatelessWidget {
  const TestMyApp({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(300, 300),
        painter: MyPainter(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Offset start = new Offset(80,60);

  @override
  void paint(Canvas canvas, Size size) {
    double p1 = -100;
    double p2 = -100;
    double p3 = 100;
    double p4 = 100;
    Offset a = Offset(p1, p2);
    Offset b = Offset(p3, p4);
    final pointMode = ui.PointMode.polygon;
    final points = [
      start,
      //Offset(p1, p2),
      a,
    ];
    final points2 = [
      start,
      Offset(p3, p4),
    ];
    print(getrotate2(a) - getrotate(p3, p4));
    Verify().setAngle(start, a, b);


    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
    canvas.drawPoints(pointMode, points2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

  double getrotate(double p1, double p2) {
    //定義偏移點
    Offset point = new Offset(p1, p2) + start;
    //獲取計算偏移量 弧度
    double direction = point.direction;
    //可以讓負的度數變成正的
    //double getangle() => direction < 0.0 ? 2 * pi + direction : direction;
    //獲取直線偏移角度
    double angle = direction * 180 / pi;
    //保留兩位小數
    String angleStr = angle.toStringAsFixed(2);
    print('tan direction $direction');
    print('角度: $angleStr°');
    return angle;
  }

  double getrotate2(Offset o1) {
    //定義偏移點
    Offset point = o1 + start;
    //獲取計算偏移量 弧度
    double direction = point.direction;
    //可以讓負的度數變成正的
    //double getangle() => direction < 0.0 ? 2 * pi + direction : direction;
    //獲取直線偏移角度
    double angle = direction * 180 / pi;
    //保留兩位小數
    String angleStr = angle.toStringAsFixed(2);
    print('tan direction $direction');
    print('角度: $angleStr°');

    return angle;
  }
}