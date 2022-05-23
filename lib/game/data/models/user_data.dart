import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/user_model.dart';

class UserData extends Equatable {
  final UserModel user;

  const UserData({required this.user,});

  factory UserData.empty() {
    return  UserData(user: UserModel.empty());
  }

  UserData copyWith({ UserModel? user, }){
    return UserData(user: user ?? this.user,);
  }

  factory UserData.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return UserData.empty();
    }
    return UserData(user: UserModel.toJson(json["user"]),);
  }

  Map<String,dynamic> toMap(){
    return {
      "user" : user,
    };
  }

  @override
  List<Object?> get props => [user];
}