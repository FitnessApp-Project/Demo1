class Record {
  String name;
  String address;
  String contact;
  String photo;
  String url;

  Record({
    required this.name,
    required this.address,
    required this.contact,
    required this.photo,
    required this.url
  });

  factory Record.fromJson(Map<String, dynamic> json){
    return Record(
        name: json['name'],
        address: json['address'],
        contact: json ['contact'],
        photo: json['photo'],
        url: json['url']
    );
  }
}