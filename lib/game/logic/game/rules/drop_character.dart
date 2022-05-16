part of '../game_bloc.dart';

class DropCharacter {
  static dropCharacter(Emitter<GameState> emit, GameState state) async {
    Map<int, Map<int, CharacterType>> boards = state.gameBoards;
    final List<Map<int, int>> previousPosition = [];
    final List<Map<int, int>> currentPosition = [];
    if (state.dropDown) {
      int lessBy = 0;
      // print("DROP");
      for (int j = 1; j <= state.col; j++) {
        int colIncrement = 0;
        bool isNonBreakable = false;
        int nonBreakable = state.row;
        List<CharacterType> newLook = [];
        List<Map<int,Map<int, CharacterType>>> nones = [];
        for (int i = state.row; i >= 1; i--) {
          // List all character in column which is not hole
          CharacterType character = boards[i]?[j] ?? CharacterType.hole;
          if(BreakCharacter.noneBreakableCharacter(character)){
            nonBreakable = 0;
            nones.add({i: { j : character}});
            isNonBreakable = true;
          }
          if (CharacterType.hole != character) {
            newLook.add(character);
          }
        }
        if (newLook.length < state.row) {
          lessBy = state.row - newLook.length;
          int k = 0;
          // drop character down
          for (int i = state.row; i > lessBy; i--) {
            Map<int, CharacterType> row = boards[i] ?? {};
            row = {...row, j: newLook[k]};
            boards[i] = row;
            k++;
          }
          // Replace remain character with new
          for (int i = lessBy; i >= 1; i--) {
            Map<int, CharacterType> row = boards[i] ?? {};
            previousPosition.add({0: j});
            row = {...row, j: CharacterGenerator.getUniqueRandomCharacter(boards, i, j)};
            boards[i] = row;
            currentPosition.add({i: j});
          }
        }
      }
      emit(state.copyWith(
          gameBoards: boards, dropDown: false, bombTouched: false, previousPosition: previousPosition));
    }
    Map<int, List<Map<int, int>>> connected = {};
    List<Map<int, int>> firstMoves = [];
    for (int i = 1; i <= state.row; i++) {
      for (int j = 1; j <= state.col; j++) {
        CharacterType type = getBoardCharacter(boards, row: i, col: j);
        connected = getConnectedCharacter(state, i, j, type);
        if (connected.isNotEmpty) {
          if (connected.entries.first.key > 1) {
            firstMoves = [...connected.entries.first.value];
          }
        }
      }
    }
    if (firstMoves.length > 2) {
      // await Future.delayed(const Duration(milliseconds: 300));
      // print(firstMoves);
      emit(
        state.copyWith(
          toBreak: firstMoves,
          planes: [],
          bulletVerticals: [],
          bulletHorizontals: [],
          bombs: [],
          superBombs: [],
        ),
      );
    }
  }
}