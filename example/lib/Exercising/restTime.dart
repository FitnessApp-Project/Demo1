import 'dart:async';
import 'package:body_detection_example/cc/tabBar.dart';
import 'package:flutter/material.dart';
import '../cc/helpers/Constants.dart';
import '../cc/setting/Setting2.dart';
import '../cc/sports menu/poseIntro.dart';
import '../cc/sports menu/undoneList.dart';
import 'package:body_detection_example/poseRecognition/provider.dart'
    as globals;
import 'package:body_detection_example/cc/sports menu/undoneList.dart';

// void main() {
//   runApp(const RestTime());
// }

class RestTime extends StatefulWidget {
  const RestTime({Key? key}) : super(key: key);

  @override
  State<RestTime> createState() => _RestTimeState();
}

class _RestTimeState extends State<RestTime> {
  int count = 0;
  bool a = false;
  late Timer timer;

  Future<int> _getTime() async {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (count > 0) {
        setState(() {
          count -= 1;
        });
      } else {
        timer.cancel();
        print("jump to tabBar");
        UndoneList.removefirst();
        print("globals.Provider.record.poseName " +
            UndoneList.getrecord().poseName);
        Future.delayed(Duration.zero, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PoseIntro(
                      SportName: UndoneList.getrecord().poseName,
                      number: UndoneList.getrecord().number,
                      Context: UndoneList.getrecord().introduction,
                      whichCardyouChoose: 2)));
        });
      }
    });
    return count;
  }

  @override
  void initState() {
    super.initState();
    count = Setting2().getRestTime();
    _getTime();
    print('init');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    count = Setting2().getRestTime();
    _getTime();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    print('setState');
  }

  @override
  Widget build(BuildContext context) {
    // setState(() { });
    // print("hahahah");
    // UndoneList.removefirst();
    // print(UndoneList.getrecord().poseName);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 360,
                height: 360,
                margin: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 15.0,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "休息時間",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    Text(
                      count.toString(),
                      style: TextStyle(fontSize: 80, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                /*  IconButton(
                    iconSize: 90,
                    highlightColor: Colors.yellow,
                    padding: const EdgeInsets.all(0),
                    icon:
                        Icon(Icons.arrow_left, size: 90.0, color: Colors.brown),
                    onPressed: () {
                      timer.cancel();
                      Navigator.push(
                          //context, MaterialPageRoute(builder: (context) => PoseIntro()));
                          context,
                          MaterialPageRoute(builder: (context) => tabBar()));
                      debugPrint('preview');
                    },
                  ),*/
                  Text(
                    // "下一個動作:\n" + UndoneList().getNextrecord().poseName,
                    "下一個動作:\n" +
                        UndoneList.getNextrecord().poseName,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
               /*   IconButton(
                    iconSize: 90,
                    highlightColor: Colors.yellow,
                    padding: const EdgeInsets.all(0),
                    icon: Icon(Icons.arrow_right,
                        size: 90.0, color: Colors.brown),
                    onPressed: () {
                      timer.cancel();
                      // UndoneList().removefirst();
                     UndoneList.removefirst();
                      Navigator.push(
                          // context, MaterialPageRoute(builder: (context) => PoseIntro()));
                          context,
                          MaterialPageRoute(builder: (context) => tabBar()));
                      print("right");
                    },
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//參考資料:
//https://medium.com/flutter-taipei/flutter-利用timer與changenotifierprovider實現background-timer-a761f700b419
