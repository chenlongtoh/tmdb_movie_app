import 'package:hive/hive.dart';
part 'genre.g.dart';

@HiveType(typeId: 3)
class Genre extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  Genre({this.id, this.name});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
