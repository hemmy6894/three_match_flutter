part of 'server_bloc.dart';

class ServerState extends Equatable {
  final String token;
  final UserModel user;
  final bool logging;
  final bool registering;
  final bool loadFriend;
  final List<TaskModel> tasks;
  final List<AssignModel> assigns;
  final List<String> phones;
  final List<PhoneModel> friends;
  final List<GenderModel> genders;
  final List<CountryModel> countries;
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
      required this.genders,
      required this.countries,
      required this.payload});

  factory ServerState.empty() {
    return ServerState(
        logging: false,
        registering: false,
        loadFriend: false,
        token: "",
        phones: const [],
        assigns: List<AssignModel>.empty(),
        tasks: List<TaskModel>.empty(),
        friends: const [],
        genders: const [],
        countries: const [],
        user: UserModel.empty(),
        payload: const {});
  }

  AssignModel? assigned({required String id}){
    for(AssignModel assigned in assigns){
      if(assigned.id == id){
        return assigned;
      }
    }
    return null;
  }

  ///  Copy with all element of Server state
  ///  $friends
  ///  $phones
  ///  $genders
  ///
  ServerState copyWith(
      {UserModel? user,
      String? token,
      Map<String, dynamic>? payload,
      bool? logging,
      bool? loadFriend,
      List<AssignModel>? assigns,
      List<TaskModel>? tasks,
      List<String>? phones,
      List<PhoneModel>? friends,
      List<GenderModel>? genders,
      List<CountryModel>? countries,
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
        genders: genders ?? this.genders,
        countries: countries ?? this.countries,
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
        countries:  CountryModel.getList(json["countries"]),
        genders:  GenderModel.getList(json["genders"]),
        tasks:  TaskModel.getList(json["tasks"]),// List<TaskModel>.toJson(json["tasks"]),
        assigns: AssignModel.getList(json["assigns"]),
        user: UserModel.toJson(json["user"]),
        payload: const {}
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "logging" : logging,
      "registering" : registering,
      "token" : token,
      "load_friend" : loadFriend,
      "user" : user.toMap(),
      // "tasks" : tasks.map((e) => e.toMap()),
      // "assigns" : assigns.toMap(),
    };
  }

  @override
  List<Object?> get props => [token,user,payload,logging,registering,phones,friends,loadFriend,assigns,tasks,countries,genders];
}
