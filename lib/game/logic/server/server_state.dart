part of 'server_bloc.dart';

class ServerState extends Equatable {
  final String token;
  final UserModel user;
  final bool logging;
  final bool registering;
  final bool loadFriend;
  final TaskList tasks;
  final AssignList assigns;
  final List<String> phones;
  final List<PhoneModel> friends;
  final Map<String, dynamic> payload;

  const ServerState(
      {required this.logging,
      required this.registering,
      required this.token,
      required this.user,
      required this.tasks,
      required this.assigns,
      required this.phones,
      required this.loadFriend,
      required this.friends,
      required this.payload});

  factory ServerState.empty() {
    return ServerState(
        logging: false,
        registering: false,
        loadFriend: false,
        token: "",
        phones: const [],
        assigns: AssignList.empty(),
        tasks: TaskList.empty(),
        friends: const [],
        user: UserModel.empty(),
        payload: const {});
  }

  ServerState copyWith(
      {UserModel? user,
      String? token,
      Map<String, dynamic>? payload,
      bool? logging,
      bool? loadFriend,
      AssignList? assigns,
      TaskList? tasks,
      List<String>? phones,
      List<PhoneModel>? friends,
      bool? registering}) {
    var states =  ServerState(
        logging: logging ?? this.logging,
        registering: registering ?? this.registering,
        loadFriend: loadFriend ?? this.loadFriend,
        user: user ?? this.user,
        assigns: assigns ?? this.assigns,
        tasks: tasks ?? this.tasks,
        phones: phones ?? this.phones,
        friends: friends ?? this.friends,
        token: token ?? this.token,
        payload: payload ?? this.payload);
    return states;
  }

  factory ServerState.fromJson(Map<String, dynamic>? json)  {
    if (json == null) {
      return ServerState.empty();
    }
    return ServerState(
        logging: json["logging"] ?? false,
        registering: json["registering"] ?? false,
        loadFriend: json["load_friend"] ?? false,
        token: json["token"] ?? "",
        phones: const [],
        friends:  PhoneModel.getList(json),
        tasks: TaskList.toJson(json["tasks"]),
        assigns: AssignList.toJson(json["assigns"]),
        user: UserModel.toJson(json["user"]),
        payload: json["payload"] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      "logging" : logging,
      "registering" : registering,
      "token" : token,
      "load_friend" : loadFriend,
      "user" : user.toMap(),
      "payload" : payload,
      "tasks" : tasks,
      "assigns" : assigns,
    };
  }

  @override
  List<Object?> get props => [token,user,payload,logging,registering,phones,friends,loadFriend,assigns,tasks];
}
