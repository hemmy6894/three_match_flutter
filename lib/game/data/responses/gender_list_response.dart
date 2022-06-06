import 'package:test_game/game/data/models/gender_list.dart';

class GenderListResponse {
  final bool success;
  final GenderList data;
  final String message;

  GenderListResponse(
      {required this.message, required this.success, required this.data});

  factory GenderListResponse.fromMap(
    Map<String, dynamic> json, {
    String response = "data",
  }) =>
      GenderListResponse(
        success: json["status"] ?? false,
        message: json["sms"] ?? "",
        data: GenderList.toJson(json[response]),
      );
}
