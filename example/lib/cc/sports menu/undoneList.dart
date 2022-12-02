
import 'package:body_detection_example/cc/poseList/poseRecordList.dart';
import 'package:body_detection_example/cc/poseList/poseRecord.dart';
import 'package:body_detection_example/cc/poseList/poseRecordService.dart';

class UndoneList {
  static poseRecordList _records = new poseRecordList(records: []);
  poseRecordList _filteredRecords = new poseRecordList(records: []);

  void setrecordList(poseRecordList rl) async {
    print("setrecord");
    _records = rl;
  }
  static void newRecords() async {
    poseRecordList records = (await poseRecordService().loadRecords()) as poseRecordList;
    if( _records.records==[]) {
      for (poseRecord record in records.records) {
        _records.records.add(record);
        print("newRecords");
      };
    }
  }

  static poseRecord getrecord() {
    print("get Record");
    return _records.records.first;
  }
  static poseRecord getNextrecord() {
      return _records.records[1];
  }
  static poseRecord getLastrecord() {
    return _records.records.last;
  }

  static void removefirst() {
    print("rencent data: " + _records.records.first.poseName);
    _records.records.remove(_records.records.first);
    print("next data: " + _records.records.first.poseName);
  }

}
