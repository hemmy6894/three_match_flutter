import 'package:test_game/game/data/models/friend_list.dart';

class FriendListResponse {
  final bool success;
  final FriendList data;
  final String message;

  FriendListResponse(
      {required this.message, required this.success, required this.data});

  factory FriendListResponse.fromMap(
    Map<String, dynamic> json, {
    String response = "data",
  }) =>
      FriendListResponse(
        success: json["status"] ?? false,
        message: json["sms"] ?? "",
        data: FriendList.toJson(json[response]),
      );
}
