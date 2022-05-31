import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String name;
  final String email;
  final String phone;

  const UserModel({required this.name, required this.email, required this.phone});

  factory UserModel.empty() {
    return const UserModel(name: "", email: "", phone: "");
  }

  UserModel copyWith({ String? name, String? email, String? phone}){
    return UserModel(name: name ?? this.name, email: email ?? this.email, phone: phone ?? this.phone);
  }

  factory UserModel.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return UserModel.empty();
    }
    return UserModel(name: json["name"] ?? "", email: json["email"] ?? "", phone: json["phone"] ?? "");
  }

  Map<String,dynamic> toMap(){
    return {
      "name" : name,
      "email" : email,
      "phone" : phone
    };
  }

  static List<UserModel>  getList(json)  {
    List<UserModel> users = [];
    try{
      for(var js in json){
        users.add(js);
      }
    }catch(e){
      users = [];
    }
    return users;
  }

  @override
  List<Object?> get props => [name,phone,email];
}