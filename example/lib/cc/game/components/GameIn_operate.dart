import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../helpers/Constants.dart';
import '../GameOver.dart';
import '../Play.dart';


const double windowWidth = 1024;
const double windowHeight = 800;

class GameIn_operate extends StatefulWidget {
  GameIn_operate({Key? key}) : super(key: key);

  @override
  State<GameIn_operate> createState() => _GameIn_operateState();
}

class _GameIn_operateState extends State<GameIn_operate> {
  late Timer timer;
  int count = 5;

  @override
  void didChangeDependencies() {
    var duration = Duration(milliseconds: 100);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        score;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 70, right: 70, top: 20, bottom: 20),
        child: Column(
          children: [
            Text(
              '最高分數: $score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute(builder: (BuildContext context) {
                 // return GameOver( currentScore: 0,);
                  return Play();
                }));
              },
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: const Text(
                  '開始',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
