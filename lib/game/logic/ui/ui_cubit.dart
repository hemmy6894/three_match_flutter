import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:test_game/game/ui/game/character.dart';

part 'ui_state.dart';

class UiCubit extends Cubit<UiState> with HydratedMixin {
  UiCubit() : super(UiState.empty()) {
    // REFILLING LIVES
    int minutes = state.fullLiveCount * 60 * 1 * 1000; // every twenty minutes over fullLiveCount
    Timer.periodic(const Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;
      emit(
        state.copyWith(
          remainingTime: (minutes ~/ state.fullLiveCount) - (now - state.lastUpdated),
        ),
      );
      if ((now - state.lastUpdated) >= (minutes / state.fullLiveCount)) {
        if (state.lastLifeCount < state.fullLiveCount) {
          incrementLife();
        }
      }
    });
  }

  decrementLife() {
    emit(state.copyWith(
        lastLifeCount: (state.lastLifeCount - 1),
        lastUpdated: DateTime.now().millisecondsSinceEpoch));
  }

  incrementLife() {
    emit(state.copyWith(
        lastLifeCount: (state.lastLifeCount + 1),
        lastUpdated: DateTime.now().millisecondsSinceEpoch));
  }

  receiveRewards({required List<Map<CharacterType, int>> rewards}) async{
    List<Map<CharacterType, int>> rds = [];
    for(Map<CharacterType,int> reward in rewards){
      bool exit = false;
      for(Map<CharacterType,int> sReward in state.rewards){
        if(mapEquals(reward, sReward)){
          rds.add({reward.entries.first.key : ( reward.entries.first.value + sReward.entries.first.value)});
          exit = true;
        }
      }
      if(!exit){
        rds.add({reward.entries.first.key : reward.entries.first.value});
      }
    }
    emit(state.copyWith(rewards: rds, received: {}));
  }

  @override
  UiState? fromJson(Map<String, dynamic> json) {
    return UiState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(UiState state) {
    return state.toJson();
  }
}
