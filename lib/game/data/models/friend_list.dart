import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/friend_model.dart';
import 'package:test_game/game/data/models/user_model.dart';

class FriendList extends Equatable {
  final List<FriendModel> friends;

  const FriendList({required this.friends,});

  factory FriendList.empty() {
    return  const FriendList(friends: []);
  }

  FriendList copyWith({ List<FriendModel>? friends,}){
    return FriendList(friends: friends ?? this.friends,);
  }

  factory FriendList.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return FriendList.empty();
    }
    return FriendList(friends: FriendModel.getList(json["friends"]), );
  }

  Map<String,dynamic> toMap(){
    return {
      "friends" : friends,
    };
  }

  @override
  List<Object?> get props => [friends];
}