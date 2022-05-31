import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/user_model.dart';

class FriendModel extends Equatable {
  final UserModel user;
  final UserModel friend;

  const FriendModel({required this.user, required this.friend});

  factory FriendModel.empty() {
    return  FriendModel(user: UserModel.empty(), friend: UserModel.empty());
  }

  FriendModel copyWith({ UserModel? user, UserModel? friend}){
    return FriendModel(user: user ?? this.user, friend: friend ?? this.friend);
  }

  factory FriendModel.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return FriendModel.empty();
    }
    return FriendModel(user: UserModel.toJson(json["owner"]), friend: UserModel.toJson(json["related"]),);
  }

  Map<String,dynamic> toMap(){
    return {
      "user" : user,
      "friend" : friend,
    };
  }

  static List<FriendModel>  getList(json)  {
    List<FriendModel> users = [];
    try{
      for(var js in json){
        users.add(FriendModel.toJson(js));
      }
    }catch(e){
      users = [];
    }
    return users;
  }

  @override
  List<Object?> get props => [friend,user];
}