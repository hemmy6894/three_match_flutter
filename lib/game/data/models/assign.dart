import 'package:equatable/equatable.dart';

class AssignModel extends Equatable {
  final String taskId;
  final String userId;

  const AssignModel({required this.taskId, required this.userId});

  factory AssignModel.empty() {
    return const AssignModel(taskId: "", userId: "");
  }

  AssignModel copyWith({ String? taskId, String? userId, }){
    return AssignModel(taskId: taskId ?? this.taskId, userId: userId ?? this.userId);
  }

  factory AssignModel.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return AssignModel.empty();
    }
    return AssignModel(taskId: json["task_id"] ?? "", userId: json["user_id"] ?? "",);
  }

  Map<String,dynamic> toMap(){
    return {
      "task_id" : taskId,
      "user_id" : userId,
    };
  }

  static List<AssignModel>  getList(json)  {
    List<AssignModel> users = [];
    try{
      for(var js in json){
        users.add(AssignModel.toJson(js));
      }
    }catch(e){
      users = [];
    }
    return users;
  }

  @override
  List<Object?> get props => [taskId,userId];
}