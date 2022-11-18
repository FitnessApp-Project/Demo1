class poseRecord {
  String poseName;
  String number;
  String introduction;
  String photo;

  poseRecord({
    required this.poseName,
    required this.number,
    required this.introduction,
    required this.photo,

  });

  factory poseRecord.fromJson(Map<String, dynamic> json){
    return poseRecord(
        poseName: json['poseName'],
        number: json['number'],
        introduction: json ['introduction'],
        photo: json['photo']
    );
  }
}