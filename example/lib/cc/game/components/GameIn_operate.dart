/*
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../helpers/Constants.dart';
//import 'package:window_size/window_size.dart';


const double windowWidth = 1024;
const double windowHeight = 800;

class GameIn_operate extends StatelessWidget {
  const GameIn_operate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 70, right: 70, top: 20, bottom: 20),
      child: Column(
        children: [
          Text(
            '最高分數:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '分數',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  iconSize: 80.0,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_left,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                          blurRadius: 8.0,
                          color: Colors.grey,
                        ),
                      ]),
                  onPressed: () => print('按下'),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  iconSize: 80.0,
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                  ),
                  onPressed: () => print('按下'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: TextButton(
                    child: Text(
                      '開始',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () => print('按下'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
