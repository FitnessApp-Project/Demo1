import 'package:flutter/material.dart';
import 'package:body_detection_example/cc/poseList/RecordList.dart';
import 'package:body_detection_example/cc/poseList/Record.dart';
import 'package:body_detection_example/cc/poseList/poseRecordList.dart';
import 'package:body_detection_example/cc/poseList/poseRecord.dart';

class UndoneList {
  static poseRecordList _records = new poseRecordList(records: []);
  poseRecordList _filteredRecords = new poseRecordList(records: []);

  void setrecordList(poseRecordList rl) async {
    print("setrecord");
    _records = rl;
  }

  poseRecord getrecord() {
    return _records.records.first;
  }
  poseRecord getNextrecord() {
      return _records.records[1];
  }
  poseRecord getLastrecord() {
    return _records.records.last;
  }

 void removefirst() {
    print("rencent data: " + _records.records.first.poseName);
    _records.records.remove(_records.records.first);
    print("next data: " + _records.records.first.poseName);
  }

}
