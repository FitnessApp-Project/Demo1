import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';

import 'package:body_detection/models/point3d.dart';
import 'dart:math';
import 'provider.dart' as globals;

class counterPaint extends CustomPainter {
  counterPaint(

  );
  final rightPointPaint = Paint()
    ..color = const Color.fromRGBO(100, 208, 218, 1);

  @override
  void paint(Canvas canvas, Size size) {
    _paintCount(canvas, size, Offset(0, 0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _paintCount(Canvas canvas, Size size, Offset position) {
    TextSpan Counter = TextSpan(
      text: globals.Provider.counter.toString() + "次",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 40,
        // height: 15
      ),
    );
    TextSpan Timer = TextSpan(
      text: globals.Provider.timer.toString() + "秒",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 40,
        // height: 15
      ),
    );
    TextSpan down = TextSpan(
      text: "請往下",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );
    TextSpan up = TextSpan(
      text: "請往上",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );
    TextSpan outOfRange = TextSpan( //超出鏡頭範圍
      text: "請將全身站在鏡頭範圍內",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );

    TextSpan sidelegraiseleft = TextSpan(
      text: "身體請朝左,左手軸壓著地板",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );
    TextSpan sidelegraiseright = TextSpan(
      text: "身體請朝右,右手軸壓著地板",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );
    TextSpan kneelinglegraiseRight = TextSpan(
      text: "雙手撐地 雙腳跪地 請抬右腿",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );
    TextSpan kneelinglegraiseLeft = TextSpan(
      text: "雙手撐地 雙腳跪地 請抬左腿",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );
    TextSpan pyramidStretchLeft = TextSpan(
      text: "請雙手朝左腳尖拉伸",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );

    TextSpan pyramidStretchRight = TextSpan(
      text: "請雙手朝右腳尖拉伸",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );

    TextSpan lungeLeft = TextSpan(
      text: "將左腳往前蹲成弓箭步",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );

    TextSpan lungeRight = TextSpan(
      text: "將右腳往前蹲成弓箭步",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );

    TextSpan statedForwardBendStretchStateLeft = TextSpan(
      text: "坐姿前彎向左腳拉伸",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );

    TextSpan statedForwardBendStretchStateRight = TextSpan(
      text: "坐姿前彎向右腳拉伸",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );

    TextSpan Done = TextSpan(
      text: "已完成",
      style: const TextStyle(
        color: Color.fromRGBO(0, 128, 255, 1),
        fontSize: 30,
        // height: 15,
      ),
    );

    if(globals.Provider.CounterOrTimer == "Timer"){
      TextPainter tp = TextPainter(text: Timer, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(size.width / 2 - 20, size.height / 2 - 10));
    }else{
      TextPainter tp = TextPainter(text: Counter, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(size.width / 2 - 20, size.height / 2 - 10));
    }

    if (globals.Provider.state == "down") {
      TextPainter tp = TextPainter(text: down, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, size.height / 2 + 10));
    } else if (globals.Provider.state == "up") {
      TextPainter tp = TextPainter(text: up, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, size.height / 2 + 10));
    } else if (globals.Provider.state == "outOfRange") {
      TextPainter tp = TextPainter(text: outOfRange, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, size.height / 2 + 10));
    }

    if (globals.Provider.sidelegraiseState == "left") {
      TextPainter tp = TextPainter(text: sidelegraiseleft, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }else if (globals.Provider.sidelegraiseState == "right") {
      TextPainter tp = TextPainter(text: sidelegraiseright, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }

    if (globals.Provider.kneelinglegraise == "left") {
      TextPainter tp = TextPainter(text: kneelinglegraiseLeft, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }else if (globals.Provider.kneelinglegraise == "right") {
      TextPainter tp = TextPainter(text: kneelinglegraiseRight, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }

    if (globals.Provider.pyramidStretchState == "left") {
      TextPainter tp = TextPainter(text: pyramidStretchLeft, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }else if (globals.Provider.pyramidStretchState == "right") {
      TextPainter tp = TextPainter(text: pyramidStretchRight, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }

    if (globals.Provider.lungeState == "left") {
      TextPainter tp = TextPainter(text: lungeLeft, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }else if (globals.Provider.lungeState == "right") {
      TextPainter tp = TextPainter(text: lungeRight, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }

    if (globals.Provider.statedForwardBendStretchState == "left") {
      TextPainter tp = TextPainter(text: statedForwardBendStretchStateLeft, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }else if (globals.Provider.statedForwardBendStretchState == "right") {
      TextPainter tp = TextPainter(text: statedForwardBendStretchStateRight, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }

    if (globals.Provider.kneelinglegraise == "Done" || globals.Provider.sidelegraiseState == "Done"
    || globals.Provider.sidelegraiseState == "Done" || globals.Provider.lungeState == "Done"
    || globals.Provider.statedForwardBendStretchState == "Done") {
      TextPainter tp = TextPainter(text: Done, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, Offset(5, 5));
    }
  }
}