part of 'server_bloc.dart';

abstract class ServerEvent {}

class ServerPullUserEvent extends ServerEvent {}

class RegisterUserEvent extends ServerEvent {
  registerUser(
      Emitter<ServerState> emit, ServerState state, String token) async {
    state = state.copyWith(logging: true);
    emit(state);
    await GameRepository.registerUser(payload: {...state.payload}, token: token)
        .then((value) {
      if (value.isLeft) {
        if (value.left.success == true) {
          UserModel user = value.left.data.user;
          String token = value.left.data.token;
          state = state.copyWith(user: user,logging: false, token: token,);
          emit(state);
          print(state.toMap());
        }
      }
    });
    emit(state.copyWith(logging: false));
  }
}

class UpdateUserEvent extends ServerEvent {
  updateUser(Emitter<ServerState> emit, ServerState state, String token) async {
    state = state.copyWith(logging: true);
    emit(state);
    await GameRepository.updateUser(payload: {...state.payload}, token: state.token)
        .then((value) {
      if (value.isLeft) {
        if (value.left.success == true) {
          UserModel user = value.left.data.user;
          String token = value.left.data.token;
          state = state.copyWith(user: user,logging: false, token: token,);
          emit(state);
        }
      }
    });
    emit(state.copyWith(logging: false));
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


class ServerPutPayload extends ServerEvent {
  final String value;
  final String key;

  ServerPutPayload({required this.value, required this.key});
  putPayload(Emitter<ServerState> emit, ServerState state) {
    final Map<String, dynamic> payload = {...state.payload, key: value};
    print(payload);
    emit(state.copyWith(payload: payload));
  }
}

class ServerDestroyPayload extends ServerEvent {
  destroyPayload(Emitter<ServerState> emit, ServerState state) {
    emit(state.copyWith(payload: {}));
  }
}

class FetchContactEvent extends ServerEvent{}
class RequestFriendEvent extends ServerEvent{}
class PullFriendEvent extends ServerEvent{}