/*class DateRecorde {
  // Init
   final int id;
   final String name;
   final int age;
  final String ability;

  DateRecorde({
     required this.id,
    required this.name,
    required this.age,
    required this.ability,
  });

  // toMap()
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "age": age,
      "ability": ability,
    };
  }

  @override
  String toString() {
    return "DateRecode{\n  id: $id\n  name: $name\n  age: $age\n  ability: $ability\n}\n\n";
  }
}*/

class DateRecorde {
  final int id;
  final String name;
  final int age;

  DateRecorde({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}