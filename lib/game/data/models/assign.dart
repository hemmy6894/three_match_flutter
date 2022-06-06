import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/task.dart';
import 'package:test_game/game/data/models/user_model.dart';

class AssignModel extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final String title;
  final String description;
  final String url;
  final UserModel user;
  final TaskModel task;

  const AssignModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.title,
    required this.description,
    required this.url,
    required this.user,
    required this.task,
  });

  factory AssignModel.empty() {
    return AssignModel(
      id: "",
      taskId: "",
      userId: "",
      title: "",
      description: "",
      url: "",
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
      user: user ?? this.user,
      task: task ?? this.task,
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
  List<Object?> get props => [id,taskId, userId,title,description,url,user.toMap(),task.toMap()];
}
