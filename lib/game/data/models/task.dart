import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String name;
  final String label;
  final String id;

  const TaskModel({required this.label, required this.name, required this.id});

  factory TaskModel.empty() {
    return const TaskModel(name: "", id: "", label: "");
  }

  TaskModel copyWith({
    String? label,
    String? name,
    String? id,
  }) {
    return TaskModel(
      label: label ?? this.label,
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  factory TaskModel.toJson(Map<String, dynamic>? json) {
    if (json == null) {
      return TaskModel.empty();
    }
    return TaskModel(
      label: json["label"] ?? "",
      name: json["name"] ?? "",
      id: json["id"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "label": label,
      "name": name,
      "id": id,
    };
  }

  static List<TaskModel> getList(json) {
    List<TaskModel> users = [];
    try {
      for (var js in json) {
        users.add(TaskModel.toJson(js));
      }
    } catch (e) {
      users = [];
    }
    return users;
  }

  @override
  List<Object?> get props => [label,name, id];
}
