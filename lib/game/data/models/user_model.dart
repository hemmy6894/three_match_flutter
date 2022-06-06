import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String genderId;
  final String countryId;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.genderId,
    required this.countryId,
  });

  factory UserModel.empty() {
    return const UserModel(
      id: "",
      name: "",
      email: "",
      phone: "",
      countryId: "",
      genderId: "",
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? genderId,
    String? countryId,
  }) {
    return UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        genderId: genderId ?? this.genderId,
        countryId: countryId ?? this.countryId,
        phone: phone ?? this.phone);
  }

  factory UserModel.toJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserModel.empty();
    }
    return UserModel(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        countryId: json["country_id"] ?? "",
        genderId: json["gender_id"] ?? "",
        phone: json["phone"] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "country_id": countryId,
      "gender_id": genderId,
    };
  }

  static List<UserModel> getList(json) {
    List<UserModel> users = [];
    try {
      for (var js in json) {
        users.add(js);
      }
    } catch (e) {
      users = [];
    }
    return users;
  }

  @override
  List<Object?> get props => [id, name, phone, email, countryId, genderId];
}
