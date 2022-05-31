import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/user_model.dart';

class UserData extends Equatable {
  final UserModel user;
  final String token;

  const UserData({required this.user,required this.token,});

  factory UserData.empty() {
    return  UserData(user: UserModel.empty(),token: "");
  }

  UserData copyWith({ UserModel? user, String? token}){
    return UserData(user: user ?? this.user, token: token ?? this.token);
  }

  factory UserData.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return UserData.empty();
    }
    return UserData(user: UserModel.toJson(json["user"]), token: json["token"] ?? "");
  }

  Map<String,dynamic> toMap(){
    return {
      "user" : user,
      "token" : token
    };
  }

  @override
  List<Object?> get props => [user,token];
}