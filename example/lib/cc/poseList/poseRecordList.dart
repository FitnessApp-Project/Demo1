import 'poseRecord.dart';

class poseRecordList {
  List<poseRecord> records = [];

  poseRecordList({
    required this.records
  });

  factory poseRecordList.fromJson(List<dynamic> parsedJson) {

    List<poseRecord> records = <poseRecord>[];

    records = parsedJson.map((i) => poseRecord.fromJson(i)).toList();

    return new poseRecordList(
      records: records,
    );
  }
}