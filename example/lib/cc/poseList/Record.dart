class Record {
  String name;
  String context;
  String photo;

  Record({
    required this.name,
    required this.context,
    required this.photo,
  });

  factory Record.fromJson(Map<String, dynamic> json){
    return new Record(
        name: json['name'],
        context: json ['context'],
        photo: json['photo']
    );
  }
}