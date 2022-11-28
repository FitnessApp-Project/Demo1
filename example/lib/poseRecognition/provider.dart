library globals;

import 'package:pausable_timer/pausable_timer.dart';


class Provider{
  static int counter = 0;
  static int timer = 0;
  static bool armLock = false;
  static bool squatLock = false;
  static bool sidelegLock = false;
  static String CounterOrTimer = "";
  static String squatState = "";
  static String sidelegraiseState = "";
  static String kneelinglegraise = "";
  static String pyramidStretchState = "";
  static String lungeState = "";
  static String statedForwardBendStretchState = "";

  static bool firstLock = true;
  static bool legpulloverLock = false;

  static String state = "down";

  static int timeCount = 0;



  static createTimer(){
    final timer = PausableTimer(Duration(seconds: 10), () => print('Timer created!'));
  }
  static paTimer(){

  }

  // late final PausableTimer Timer =
  //   PausableTimer(Duration(seconds: 1),
  //     (){timeCount++;
  //     print("計時 ：" + timeCount.toString() + "秒");
  // });

}

