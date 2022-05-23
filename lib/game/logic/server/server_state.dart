part of 'server_bloc.dart';

class ServerState extends Equatable {
  final String token;
  final UserModel user;
  final bool logining;
  final bool registering;
  final Map<String,dynamic> payload;

  const ServerState({required this.logining, required this.registering, required this.token,required this.user,required this.payload});

  factory ServerState.empty() {
    return  ServerState(logining: false, registering : false, token: "", user: UserModel.empty(), payload: const {});
  }

  ServerState copyWith({ UserModel? user, String? token, Map<String,dynamic>? payload, bool? logining, bool? registering}){
    return ServerState(logining: logining ?? this.logining, registering: registering ?? this.registering, user: user ?? this.user, token: token ?? this.token, payload: payload ?? this.payload);
  }

  @override
  List<Object?> get props => [token,user,payload,logining,registering];
}