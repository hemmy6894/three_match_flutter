import 'package:equatable/equatable.dart';
import 'package:test_game/common/helpers/three.dart';
import 'package:test_game/game/data/models/task.dart';
import 'package:test_game/game/data/models/user_model.dart';

class AssignModel extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final String title;
  final String description;
  final String url;
  final String type;
  final DateTime startAt;
  final DateTime endAt;
  final UserModel user;
  final TaskModel task;

  const AssignModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.title,
    required this.description,
    required this.url,
    required this.type,
    required this.user,
    required this.task,
    required this.startAt,
    required this.endAt,
  });

  factory AssignModel.empty() {
    return AssignModel(
      id: "",
      taskId: "",
      userId: "",
      title: "",
      description: "",
      url: "",
      type: "user",
      startAt: DateTime.now(),
      endAt: DateTime.now(),
      user: UserModel.empty(),
      task: TaskModel.empty(),
    );
  }

  AssignModel copyWith({
    String? id,
    String? taskId,
    String? userId,
    String? title,
    String? description,
    String? url,
    String? type,
    DateTime? startAt,
    DateTime? endAt,
    UserModel? user,
    TaskModel? task,
  }) {
    return AssignModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      type: type ?? this.type,
      user: user ?? this.user,
      task: task ?? this.task,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
    );
  }

  factory AssignModel.toJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AssignModel.empty();
    }
    return AssignModel(
      id: json["id"] ?? "",
      taskId: json["task_id"] ?? "",
      userId: json["user_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      url: json["url"] ?? "",
      type: json["type"] ?? "",
      startAt: ThreeMatchHelper.convertDate(json["start_at"]),
      endAt: ThreeMatchHelper.convertDate(json["end_at"]),
      user: UserModel.toJson(json["user"]),
      task: TaskModel.toJson(json["task"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "task_id": taskId,
      "user_id": userId,
      "title": title,
      "description": description,
      "url": url,
      "type": type,
      "start_at": startAt.toString(),
      "end_at": endAt.toString(),
      "user": user.toMap(),
      "task": task.toMap(),
    };
  }

  static List<AssignModel> getList(json) {
    List<AssignModel> users = [];
    try {
      for (var js in json) {
        users.add(AssignModel.toJson(js));
      }
    } catch (e) {
      users = [];
    }
    return users;
  }

  @override
  List<Object?> get props => [id,taskId, userId,title,description,url,user.toMap(),task.toMap(),type];
}
