import 'package:test_game/game/data/models/user_data.dart';

class UserResponse {
  final bool success;
  final UserData data;
  final String message;

  UserResponse(
      {required this.message, required this.success, required this.data});

  factory UserResponse.fromMap(
    Map<String, dynamic> json, {
    String response = "data",
  }) =>
      UserResponse(
        success: json["status"] ?? false,
        message: json["sms"] ?? "",
        data: UserData.toJson(json[response]),
      );
}
