import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/user_model.dart';

class UserList extends Equatable {
  final List<UserModel> users;

  const UserList({required this.users,});

  factory UserList.empty() {
    return  const UserList(users: []);
  }

  UserList copyWith({ List<UserModel>? users,}){
    return UserList(users: users ?? this.users,);
  }

  factory UserList.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return UserList.empty();
    }
    return UserList(users: UserModel.getList(json), );
  }

  Map<String,dynamic> toMap(){
    return {
      "users" : users,
    };
  }

  @override
  List<Object?> get props => [users];
}