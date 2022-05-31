import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String name;
  final String id;

  const TaskModel({required this.name, required this.id});

  factory TaskModel.empty() {
    return const TaskModel(name: "", id: "");
  }

  TaskModel copyWith({ String? name, String? id, }){
    return TaskModel(name: name ?? this.name, id: id ?? this.id);
  }

  factory TaskModel.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return TaskModel.empty();
    }
    return TaskModel(name: json["name"] ?? "", id: json["id"] ?? "",);
  }

  Map<String,dynamic> toMap(){
    return {
      "name" : name,
      "id" : id,
    };
  }

  static List<TaskModel>  getList(json)  {
    List<TaskModel> users = [];
    try{
      for(var js in json){
        users.add(TaskModel.toJson(js));
      }
    }catch(e){
      users = [];
    }
    return users;
  }

  @override
  List<Object?> get props => [name,id];
}