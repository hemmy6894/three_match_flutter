import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/task.dart';

class TaskList extends Equatable {
  final List<TaskModel> tasks;

  const TaskList({required this.tasks,});

  factory TaskList.empty() {
    return  const TaskList(tasks: []);
  }

  TaskList copyWith({ List<TaskModel>? tasks,}){
    return TaskList(tasks: tasks ?? this.tasks,);
  }

  factory TaskList.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return TaskList.empty();
    }
    return TaskList(tasks: TaskModel.getList(json["tasks"]), );
  }

  Map<String,dynamic> toMap(){
    return {
      "tasks" : tasks,
    };
  }

  @override
  List<Object?> get props => [tasks];
}