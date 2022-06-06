import 'package:equatable/equatable.dart';

class GenderModel extends Equatable {
  final String name;
  final String id;

  const GenderModel({required this.name, required this.id});

  factory GenderModel.empty() {
    return const GenderModel(name: "", id: "",);
  }

  GenderModel copyWith({
    String? name,
    String? id,
  }) {
    return GenderModel(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  factory GenderModel.toJson(Map<String, dynamic>? json) {
    if (json == null) {
      return GenderModel.empty();
    }
    return GenderModel(
      name: json["name"] ?? "",
      id: json["id"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "id": id,
    };
  }

  static List<GenderModel> getList(json) {
    List<GenderModel> users = [];
    try {
      for (var js in json) {
        users.add(GenderModel.toJson(js));
      }
    } catch (e) {
      users = [];
    }
    return users;
  }

  @override
  List<Object?> get props => [name, id];
}
