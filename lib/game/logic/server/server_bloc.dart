import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/user_model.dart';
import 'package:test_game/game/data/repositories/game.dart';

part 'server_event.dart';

part 'server_state.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> {
  ServerBloc() : super(ServerState.empty()) {
    on<RegisterUserEvent>((event, emit) async {
        await event.registerUser(emit, state, "token");
    });

    on<ServerPutPayload>((event, emit) async {
      await event.putPayload(emit, state);
    });

    on<ServerDestroyPayload>((event, emit) async {
      await event.destroyPayload(emit, state);
    });
  }
}

loginUser(Emitter<ServerState> emit, ServerState state){

}

pullUser(Emitter<ServerState> emit, ServerState state, String token) async{

}
