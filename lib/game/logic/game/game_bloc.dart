import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/ui/game/character.dart';

part 'game_event.dart';
part 'game_state.dart';
part 'game_function.dart';

class GameBlock extends Bloc<GameEvent, GameState> {
  GameBlock() : super(GameState.empty()) {
    on<GameStartEvent>((event, emit) async {
       startGameLevel1(emit,state);
    });

    on<GameClickCharacterEvent>((event, emit) async {
      characterClicked(emit,state, event.row,event.col);
    });

    on<GameMatchCharacterStateEvent>((event, emit) async {
      emit(state.copyWith(match: event.match));
    });

    on<GameMatchCharacterEvent>((event, emit) async {
      await matchCharacter(emit, state);
    });

    on<GameBreakMatchEvent>((event, emit) async {
      await breakMatch(emit, state);
    });

    on<GameDropCharacterEvent>((event, emit) async {
      await dropCharacter(emit, state);
    });

    on<GameMoveCharacterEvent>((event, emit) async {
      moveCharacter(emit, state);
    });

    on<GameClearCharacterEvent>((event, emit) async {
      clearClick(emit, state);
    });
  }


  @override
  void onChange(Change<GameState> change) {
    // TODO: implement onChange
    // print(change.currentState.gameBoards);
    super.onChange(change);
  }
}