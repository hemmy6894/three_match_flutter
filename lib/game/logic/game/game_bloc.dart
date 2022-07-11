import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/position.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/ui/game/character.dart';

part 'game_event.dart';
part 'game_state.dart';
part 'game_function.dart';
part 'rules/helpers.dart';
part 'rules/levels.dart';
part 'rules/character_generator.dart';
part 'rules/break_character.dart';
part 'rules/drop_character.dart';
part 'rules/special_character.dart';
part 'rules/bomb_move.dart';

class GameBlock extends Bloc<GameEvent, GameState> {
  GameBlock() : super(GameState.empty()) {
    on<GameStartEvent>((event, emit) async {
       await GameLevels.startGame(emit,state, event);
    });

    on<GameClickCharacterEvent>((event, emit) async {
      characterClicked(emit,state, event.row,event.col);
    });

    on<GameCatchHelperEvent>((event, emit) async {
      await Helpers.catchHelper(emit,state, event);
    });

    on<GameIsCapturedEvent>((event, emit) async {
      Helpers.isCaptured(emit,state);
    });

    on<GameMatchCharacterStateEvent>((event, emit) async {
      emit(state.copyWith(match: event.match));
    });

    on<GameMatchCharacterEvent>((event, emit) async {
      await matchCharacter(emit, state);
    });

    on<GameBreakMatchEvent>((event, emit) async {
      await BreakCharacter.breakMatch(emit, state);
    });

    on<GameDropCharacterEvent>((event, emit) async {
      await DropCharacter.dropCharacter(emit, state);
    });

    on<GameMoveCharacterEvent>((event, emit) async {
      moveCharacter(emit, state);
    });

    on<GameClearCharacterEvent>((event, emit) async {
      clearClick(emit, state);
    });

    on<GameClearHelperEvent>((event, emit) async {
      emit(state.copyWith(reduceHelperReward: CharacterType.hole));
    });

    on<GameClickBoosterEvent>((event, emit)  {
      event.boosterClicked(emit, state, event);
    });

    on<GameClearBoosterClickedEvent>((event, emit)  {
      event.boosterClear(emit, state);
    });

    on<GameCheckIfHasNextMoveEvent>((event, emit)  async{
      await event.checkHasNextMove(emit, state);
    });

    on<ClearBlastEvent>((event, emit)  async{
      await clearBlast(emit, state, event);
    });

    on<GameIncrementMovesEvent>((event,emit){
      emit(state.copyWith(moves: state.moves + event.moves));
    });
  }


  @override
  void onChange(Change<GameState> change) {
    super.onChange(change);
  }
}