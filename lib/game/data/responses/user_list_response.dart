import 'package:test_game/game/data/models/user_data.dart';
import 'package:test_game/game/data/models/user_list.dart';

class UserListResponse {
  final bool success;
  final UserList data;
  final String message;

  UserListResponse(
      {required this.message, required this.success, required this.data});

  factory UserListResponse.fromMap(
    Map<String, dynamic> json, {
    String response = "data",
  }) =>
      UserListResponse(
        success: json["status"] ?? false,
        message: json["sms"] ?? "",
        data: UserList.toJson(json[response]),
      );
}
