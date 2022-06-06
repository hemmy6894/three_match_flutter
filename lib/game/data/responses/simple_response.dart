import 'package:test_game/game/data/models/user_data.dart';
import 'package:test_game/game/data/models/user_list.dart';

class SimpleResponse {
  final bool success;
  final String message;

  SimpleResponse(
      {required this.message, required this.success,});

  factory SimpleResponse.fromMap(
    Map<String, dynamic> json, {
    String response = "data",
  }) =>
      SimpleResponse(
        success: json["status"] ?? false,
        message: json["sms"] ?? "",
      );
}
