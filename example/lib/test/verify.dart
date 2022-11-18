import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Verify {
//  late Offset start=new Offset(0, 0);
  late double angle;
  static int c = 0;
  static bool b = true;

  void setAngle(Offset start, Offset p1, Offset p2) {
    Offset part1 = p1 -start;
    Offset part2 = p2 -start;
    double direction1 = part1.direction;
    double direction2 = part2.direction;
    double positiveRad1() => direction1 < 0 ? 2 * pi + direction1 : direction1;
    double positiveRad2() => direction2 < 0 ? 2 * pi + direction2 : direction2;
    double angle1 = positiveRad1() * 180 / pi;
    double angle2 = positiveRad2() * 180 / pi;
    //print("p1: $p1");
    //print("p2: $p2");
    angle = (angle1 - angle2).abs();
    print(angle.abs());
  }
  double getAngle(){
    return angle;
  }
}

//參考:https://juejin.cn/post/7005347352798035999