import 'package:flutter/material.dart';

import '../helpers/Constants.dart';

const double windowWidth = 1024;
const double windowHeight = 800;

class GameOver extends StatelessWidget {
  final int currentScore;

  const GameOver({required this.currentScore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Text(
              "Game Over",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 150,
              width: double.infinity,
              margin: EdgeInsets.only(left: 50, right: 50, top: 60, bottom: 20),
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFFFD4A3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                "本次分數: ${currentScore.toString()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
