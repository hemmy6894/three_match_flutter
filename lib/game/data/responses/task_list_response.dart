import 'package:test_game/game/data/models/assign_list.dart';

class AssignListResponse {
  final bool success;
  final AssignList data;
  final String message;

  AssignListResponse(
      {required this.message, required this.success, required this.data});

  factory AssignListResponse.fromMap(
    Map<String, dynamic> json, {
    String response = "data",
  }) =>
      AssignListResponse(
        success: json["status"] ?? false,
        message: json["sms"] ?? "",
        data: AssignList.toJson(json[response]),
      );
}
