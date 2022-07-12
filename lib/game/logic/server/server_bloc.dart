import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:test_game/game/data/models/assign.dart';
import 'package:test_game/game/data/models/country.dart';
import 'package:test_game/game/data/models/friend_model.dart';
import 'package:test_game/game/data/models/gender.dart';
import 'package:test_game/game/data/models/phone.dart';
import 'package:test_game/game/data/models/task.dart';
import 'package:test_game/game/data/models/user_model.dart';
import 'package:test_game/game/data/repositories/game.dart';

part 'server_event.dart';

part 'server_state.dart';

class ServerBloc extends Bloc<ServerEvent, ServerState> with HydratedMixin {
  ServerBloc() : super(ServerState.empty()) {
    on<RegisterUserEvent>((event, emit) async {
      await event.registerUser(emit, state, "token");
    });

    on<UpdateUserEvent>((event, emit) async {
      await event.updateUser(emit, state, "token");
    });

    on<ServerPutPayload>((event, emit) async {
      await event.putPayload(emit, state);
    });

    on<ServerRemovePayload>((event, emit) async {
      await event.removePayload(emit, state);
    });

    on<ServerDestroyPayload>((event, emit) async {
      await event.destroyPayload(emit, state);
    });

    on<FetchContactEvent>((event, emit) async {
      await fetchContactEvent();
    });

    on<RequestFriendEvent>((event, emit) async {
      await friendRequest();
    });

    on<PullFriendEvent>((event, emit) async {
      await friends(emit);
    });

    on<PullTaskEvent>((event, emit) async {
      await event.pullTask(emit,state);
    });

    on<WonTaskEvent>((event, emit) async {
      await event.wonTask(emit,state);
    });

    on<AssignTaskEvent>((event, emit) async {
      await event.assignTask(emit,state);
    });

    on<PullAssignmentEvent>((event, emit) async {
      await event.pullAssignment(emit,state);
    });

    on<PullCountryEvent>((event, emit) async {
      await event.pullCountries(emit,state);
    });

    on<PullGenderEvent>((event, emit) async {
      await event.pullGenders(emit,state);
    });

  }

  fetchContactEvent() async{
    try {
      List<Contact> contacts = await ContactsService.getContacts(
          withThumbnails: false, photoHighResolution: false);
      List<String> conts = [];
      for (Contact any in contacts) {
        if (any.phones!.isNotEmpty) {
          List<Item> phones = any.phones ?? [];
          for (Item phone in phones) {
            if (phone.value != null) {
              String phoneNumber =
              (phone.value ?? "").trim().replaceAll(" ", "");
              String fistChar = phoneNumber[0];
              if (fistChar == "0") {
                phoneNumber = phoneNumber.replaceFirst("0", "+255");
              }
              conts.add(phoneNumber.replaceFirst("+", ""));
            }
          }
        }
      }
      List<String> myNumbers = [];
      for (String con in conts) {
        if (!myNumbers.contains(con)) {
          myNumbers.add(con);
        }
      }
      emit(state.copyWith(phones: []));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(phones: myNumbers));
      // print(state.phones);
      // print(myNumbers);
    } catch (e) {
      print(e);
    }
  }

  friendRequest() async {
    List<String> chunks = [];
    int i = 0;
    int j = 0;
    for (var frd in state.phones) {
      chunks.add(frd);
      if (i > 80) {
        for(String ch in chunks){
          // if(ch.contains("693143871")){
            print("$ch POSITION ${j++}");
          // }
        }
        await GameRepository.friendRequest(
                payload: {"friend": chunks}, token: state.token)
            .then((value) {
          if (value.isLeft) {
            add(PullFriendEvent());
          }
          if (value.isRight) {}
        });
        i = 0;
        chunks = [];
      }
      i++;
    }
  }

  friends(Emitter<ServerState> emit) async {
    emit(state.copyWith(loadFriend: true));
    await GameRepository.friends(payload: {"f": ""}, token: state.token)
        .then((value) async {
      if (value.isLeft) {
        // print(value.left.data.friends);
        List<Map<String, dynamic>> friends = [];
        for (FriendModel friend in value.left.data.friends) {
          friends.add({"phone": friend.friend.phone, "name" : friend.friend.name, "id" : friend.friend.id });
        }
        List<PhoneModel> phones = [];
        for (var js in friends) {
          try {
            List<Contact> contacts = await ContactsService.getContactsForPhone(
                js["phone"],
                withThumbnails: false,
                photoHighResolution: false);
            for (Contact contact in contacts) {
              js["displayName"] = contact.displayName ?? js["name"];
            }
            if(contacts.isEmpty){
              js["displayName"] = js["name"];
            }
          }catch(e){
            js["displayName"] = js["name"] ?? (js["phone"]??"No name");
          }
          phones.add(PhoneModel.fromJson(js));
        }
        emit(state.copyWith(friends: phones, loadFriend: false));
      }
      if (value.isRight) {
        emit(state.copyWith(loadFriend: false));
      }
    });
  }

  @override
  ServerState? fromJson(Map<String, dynamic> json) {
    return ServerState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ServerState state) {
    return state.toMap();
  }
}

loginUser(Emitter<ServerState> emit, ServerState state) {}

pullUser(Emitter<ServerState> emit, ServerState state, String token) async {}
