library globals;

import 'package:pausable_timer/pausable_timer.dart';
import 'package:body_detection_example/cc/sports menu/undoneList.dart';
import 'package:body_detection_example/cc/poseList/poseRecord.dart';
import 'package:body_detection_example/cc/poseList/poseRecordList.dart';
import 'package:body_detection_example/cc/poseList/poseRecordService.dart';
class Provider{
  static int counter = 0;
  static int timer = 0;
  static bool armLock = false;
  static bool squatLock = false;
  static bool sidelegLock = false;
  static String CounterOrTimer = "";

  static String squatState = "";
  static String legpulloverState = "";
  static String sidelegraiseState = "";
  static String kneelinglegraiseState = "";
  static String pyramidStretchState = "";
  static String lungeState = "";
  static String statedForwardBendStretchState = "";

  static bool firstLock = true;
  static bool legpulloverLock = false;
  static String state = "down";
  static int timeCount = 0;
  // static poseRecordList newUndoneList = new poseRecordList(records: []);
  //
  // static void getRecords() async {
  //   poseRecordList records = (await poseRecordService().loadRecords()) as poseRecordList;
  //     for (poseRecord record in records.records) {
  //       newUndoneList.records.add(record);
  //       print("ok");
  //     };
  // }

  // static UndoneList undoneList = UndoneList();
  // static poseRecord record = undoneList.getrecord();



  static void initVariables(){
    counter = 0;
    timer = 0;
    armLock = false;
    squatLock = false;
    sidelegLock = false;
    CounterOrTimer = "";

    squatState = "";
    sidelegraiseState = "";
    kneelinglegraiseState = "";
    pyramidStretchState = "";
    lungeState = "";
    statedForwardBendStretchState = "";

    firstLock = true;
    legpulloverLock = false;
    state = "down";
    timeCount = 0;
  }


  static createTimer(){
    final timer = PausableTimer(Duration(seconds: 10), () => print('Timer created!'));
  }


  // late final PausableTimer Timer =
  //   PausableTimer(Duration(seconds: 1),
  //     (){timeCount++;
  //     print("計時 ：" + timeCount.toString() + "秒");
  // });

}

