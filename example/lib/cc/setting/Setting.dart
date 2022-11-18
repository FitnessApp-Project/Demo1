/*
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:body_detection_example/test/Sports%20menu/poselist.dart';
import 'package:body_detection_example/test/helpers/Constants.dart';
import 'package:provider/provider.dart';

const double BoxHeight = 200.0;
const double gap = 5.0;

Widget titlesample(String context) {
  return Text(
    context,
    style: TextStyle(
      fontSize: 20,
      color: Colors.black,
      height: 2,
      fontWeight: FontWeight.bold,
    ),
  );
}

Text textsample(String context) {
  return Text(
    context,
    style: TextStyle(
      fontSize: 20,
      color: Colors.black,
      height: 2,
    ),
  );
}

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Text(
            '設定',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: kPrimaryLightColor,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
          padding: EdgeInsets.all(10),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                style: BorderStyle.solid, color: Colors.grey, width: 3),
          ),
          child: Column(children: [
            titlesample('帳戶設定'),
            //Divider(height: 3.0,color: Colors.grey,),
            textsample('個人資料'),
            textsample('帳密設定'),
          ]),
        ),
        Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
          padding: EdgeInsets.all(10),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                style: BorderStyle.solid, color: Colors.grey, width: 3),
          ),
          child: Column(mainAxisSize: MainAxisSize.max, children: [

            textsample('帳戶設定'),
            textsample('個人資料'),
            textsample('帳密設定'),
          ]),
        ),
        Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
          padding: EdgeInsets.all(10),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                style: BorderStyle.solid, color: Colors.grey, width: 3),
          ),
          child: Column(children: [
            textsample('帳戶設定'),
            textsample('個人資料'),
            textsample('帳密設定'),
          ]),
        ),
      ],
    );
  }
}
*/
