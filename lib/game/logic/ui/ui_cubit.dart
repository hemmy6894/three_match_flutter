import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:test_game/game/data/models/game/reward.dart';
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

  receiveRewards({required List<RewardModel> rewards}) async{
    List<RewardModel> rds = [];
    for(RewardModel reward in rewards){
      bool exit = false;
      for(RewardModel sReward in state.rewards){
        if(reward.character == sReward.character){
          rds.add(RewardModel(character: reward.character, amount: reward.amount + sReward.amount));
          exit = true;
        }
      }
      if(!exit){
        rds.add(RewardModel(character: reward.character, amount: reward.amount));
      }
    }
    emit(state.copyWith(rewards: rds, received: {}));
  }

  reduceReward({CharacterType characterType = CharacterType.hole, int amount = 0}){
    List<RewardModel> rds = [];
    for(RewardModel reward in state.rewards){
      if(reward.character == characterType){
        rds.add(RewardModel(character: reward.character, amount: reward.amount - amount));
      }else{
        rds.add(RewardModel(character: reward.character, amount: reward.amount));
      }
    }
    emit(state.copyWith(rewards: rds));
  }

  @override
  UiState? fromJson(Map<String, dynamic> json) {
    return UiState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(UiState state) {
    return state.toJson();
  }

  @override
  onChange(Change<UiState> change){
    super.onChange(change);
  }
}
