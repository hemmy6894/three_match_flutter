part of 'server_bloc.dart';

abstract class ServerEvent {}

class ServerPullUserEvent extends ServerEvent {}

class RegisterUserEvent extends ServerEvent {
  registerUser(
      Emitter<ServerState> emit, ServerState state, String token) async {
    emit(state.copyWith(logining: true));
    await GameRepository.registerUser(payload: {...state.payload}, token: token)
        .then((value) {
          print(value.either((left) {print(left.data);}, (right) {print(right.message);}));
      if (value.isLeft) {
        if (value.left.success == true) {
          emit(state.copyWith(user: value.left.data.user,logining: false));
        }
      }
    });
    emit(state.copyWith(logining: false));
  }
}

class ServerUserTokenEvent extends ServerEvent {
  getUserToken(
      Emitter<ServerState> emit, ServerState state, String token) async {
    emit(state.copyWith(registering: true));
    await GameRepository.getUserToken(payload: {...state.payload}, token: token)
        .then((value) {
      if (value.isLeft) {
        if (value.left.success == true) {
          emit(
            state.copyWith(
              registering: false,
              user: value.left.data.user,
            ),
          );
        }
      }
    });
    emit(state.copyWith(registering: false));
  }
}


class ServerPutPayload implements ServerEvent {
  final String value;
  final String key;

  ServerPutPayload({required this.value, required this.key});
  putPayload(Emitter<ServerState> emit, ServerState state) {
    final Map<String, dynamic> payload = {...state.payload, key: value};
    emit(state.copyWith(payload: payload));
  }
}

class ServerDestroyPayload implements ServerEvent {
  destroyPayload(Emitter<ServerState> emit, ServerState state) {
    emit(state.copyWith(payload: {}));
  }
}