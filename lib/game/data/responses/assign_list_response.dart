import 'package:test_game/game/data/models/task_list.dart';

class TaskListResponse {
  final bool success;
  final TaskList data;
  final String message;

  TaskListResponse(
      {required this.message, required this.success, required this.data});

  factory TaskListResponse.fromMap(
    Map<String, dynamic> json, {
    String response = "data",
  }) =>
      TaskListResponse(
        success: json["status"] ?? false,
        message: json["sms"] ?? "",
        data: TaskList.toJson(json[response]),
      );
}
