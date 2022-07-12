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
          state = state.copyWith(
            user: user,
            logging: false,
            token: token,
          );
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
    await GameRepository.updateUser(
            payload: {...state.payload}, token: state.token)
        .then((value) {
      if (value.isLeft) {
        if (value.left.success == true) {
          UserModel user = value.left.data.user;
          String token = value.left.data.token;
          state = state.copyWith(
            user: user,
            logging: false,
            token: token,
          );
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
  final dynamic value;
  final String key;

  ServerPutPayload({required this.value, required this.key});

  putPayload(Emitter<ServerState> emit, ServerState state) {
    final Map<String, dynamic> payload = {...state.payload, key: value};
    emit(state.copyWith(payload: payload));
  }
}

class ServerRemovePayload extends ServerEvent {
  final String key;

  ServerRemovePayload({required this.key});

  removePayload(Emitter<ServerState> emit, ServerState state) {
    Map<String, dynamic> payload = {};
    state.payload.entries.map((e) {
      if (e.key != key) {
        payload = {...payload, e.key: e.value};
      }
    });
    emit(state.copyWith(payload: payload));
  }
}

class ServerDestroyPayload extends ServerEvent {
  destroyPayload(Emitter<ServerState> emit, ServerState state) {
    emit(state.copyWith(payload: {}));
  }
}

class FetchContactEvent extends ServerEvent {}

class RequestFriendEvent extends ServerEvent {}

class PullFriendEvent extends ServerEvent {}

class PullTaskEvent extends ServerEvent {
  pullTask(Emitter<ServerState> emit, ServerState state) async {
    emit(state.copyWith(logging: true));

    await GameRepository.tasks(payload: {"": ""}, token: state.token)
        .then((response) {
      response.either((left) {
        emit(state.copyWith(logging: false, tasks: left.data.tasks));
      }, (right) {
        emit(state.copyWith(logging: false));
      });
    });
  }
}

class WonTaskEvent extends ServerEvent {
  final String taskId;
  WonTaskEvent({required this.taskId});
  wonTask(Emitter<ServerState> emit, ServerState state) async {
    emit(state.copyWith(logging: true));
    bool win = false;
    await GameRepository.wonTask(taskId, payload: {"": ""}, token: state.token)
        .then((response) {
      response.either((left) async {
        win = true;
      }, (right) {
        emit(state.copyWith(logging: false));
      });
    });
    if(win){
      await GameRepository.pullAssigns(
          payload: {...state.payload}, token: state.token)
          .then((value) {
        value.either((left) {
          emit(state.copyWith(
            logging: false,
            assigns: left.data.assigns,
          ));
        }, (right) {
          emit(state.copyWith(
            logging: false,
          ));
        });
      });
    }
  }
}

class AssignTaskEvent extends ServerEvent {
  assignTask(Emitter<ServerState> emit, ServerState state) async {
    emit(state.copyWith(logging: true));
    await GameRepository.assignTask(
            payload: {...state.payload}, token: state.token)
        .then((value) {
      value.either((left) {
        emit(state.copyWith(
          logging: false,
        ));
      }, (right) {
        emit(state.copyWith(
          logging: false,
        ));
      });
    });
  }
}

class PullAssignmentEvent extends ServerEvent {
  pullAssignment(Emitter<ServerState> emit, ServerState state) async {
    emit(state.copyWith(logging: true));
    await GameRepository.pullAssigns(
            payload: {...state.payload}, token: state.token)
        .then((value) {
      value.either((left) {
        emit(state.copyWith(
          logging: false,
          assigns: left.data.assigns,
        ));
      }, (right) {
        emit(state.copyWith(
          logging: false,
        ));
      });
    });
  }
}

class PullGenderEvent extends ServerEvent {
  pullGenders(Emitter<ServerState> emit, ServerState state) async {
    emit(state.copyWith(logging: true));
    await GameRepository.getGenders(
            payload: {...state.payload}, token: state.token)
        .then((value) {
      value.either((left) {
        emit(state.copyWith(
          logging: false,
          genders: left.data.genders,
        ));
      }, (right) {
        emit(state.copyWith(
          logging: false,
        ));
      });
    });
  }
}

class PullCountryEvent extends ServerEvent {
  pullCountries(Emitter<ServerState> emit, ServerState state) async {
    emit(state.copyWith(logging: true));
    await GameRepository.getCountries(
            payload: {...state.payload}, token: state.token)
        .then((value) {
      value.either((left) {
        emit(state.copyWith(
          logging: false,
          countries: left.data.countries,
        ));
      }, (right) {
        emit(state.copyWith(
          logging: false,
        ));
      });
    });
  }
}
