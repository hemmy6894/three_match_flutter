import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/assign.dart';
import 'package:test_game/game/data/models/friend_model.dart';
import 'package:test_game/game/data/models/user_model.dart';

class AssignList extends Equatable {
  final List<AssignModel> assigns;

  const AssignList({required this.assigns,});

  factory AssignList.empty() {
    return  const AssignList(assigns: []);
  }

  AssignList copyWith({ List<AssignModel>? assigns,}){
    return AssignList(assigns: assigns ?? this.assigns,);
  }

  factory AssignList.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return AssignList.empty();
    }
    return AssignList(assigns: AssignModel.getList(json["assigns"]), );
  }

  Map<String,dynamic> toMap(){
    return {
      "assigns" : assigns,
    };
  }

  @override
  List<Object?> get props => [assigns];
}