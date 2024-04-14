import 'package:hive/hive.dart';
part 'video.g.dart';

@HiveType(typeId: 2)
class Video extends HiveObject {
  @HiveField(1)
  String? key;

  @HiveField(2)
  String? site;

  @HiveField(3)
  String? type;

  @HiveField(4)
  String? id;

  Video({
    this.key,
    this.site,
    this.type,
    this.id,
  });

  Video.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    site = json['site'];
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['key'] = key;
    data['site'] = site;
    data['type'] = type;
    data['id'] = id;
    return data;
  }
}
