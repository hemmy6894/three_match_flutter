import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  final String name;
  final String id;

  const CountryModel({required this.name, required this.id});

  factory CountryModel.empty() {
    return const CountryModel(name: "", id: "",);
  }

  CountryModel copyWith({
    String? name,
    String? id,
  }) {
    return CountryModel(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  factory CountryModel.toJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CountryModel.empty();
    }
    return CountryModel(
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

  static List<CountryModel> getList(json) {
    List<CountryModel> users = [];
    try {
      for (var js in json) {
        users.add(CountryModel.toJson(js));
      }
    } catch (e) {
      users = [];
    }
    return users;
  }

  @override
  List<Object?> get props => [name, id];
}
