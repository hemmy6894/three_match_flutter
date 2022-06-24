part of '../game_bloc.dart';

class DropCharacter {
  static dropCharacter(Emitter<GameState> emit, GameState state) async {
    Map<int, Map<int, CharacterType>> boards = state.gameBoards;
    final List<PositionModel> previousPosition = [];
    final List<PositionModel> currentPosition = [];
    if (state.dropDown) {
      int lessBy = 0;
      // print("DROP");
      for (int j = 1; j <= state.col; j++) {
        int colIncrement = 0;
        bool isNonBreakable = false;
        int nonBreakable = state.row;
        List<CharacterType> newLook = [];
        Map<int, CharacterType> nones = {};
        for (int i = state.row; i >= 1; i--) {
          // List all character in column which is not hole
          CharacterType character = boards[i]?[j] ?? CharacterType.hole;
          if (BreakCharacter.notMovingCharacter(character)) {
            nones = {...nones, i: character};
          } else if (CharacterType.hole != character) {
            newLook.add(character);
          }
        }
        if (newLook.length < state.row) {
          lessBy = state.row - (newLook.length);
          // print("LOOP $lessBy ROW NUM ${state.row} LENGTH ${newLook.length} none ${nones.length}");
          int k = 0;
          // drop character down
          for (int i = state.row; i > lessBy; i--) {
            Map<int, CharacterType> row = boards[i] ?? {};
            CharacterType rowNotMove = nones[i] ?? CharacterType.hole;
            if (BreakCharacter.notMovingCharacter(rowNotMove)) {
              row = {...row, j: rowNotMove};
              boards[i] = row;
              // k++;
            } else if (k < newLook.length) {
              row = {...row, j: newLook[k]};
              boards[i] = row;
              k++;
            }
          }
          // Replace remain character with new
          for (int i = lessBy; i >= 1; i--) {
            Map<int, CharacterType> row = boards[i] ?? {};
            previousPosition.add(PositionModel(row: 0, col: j));
            CharacterType rowNotMove = nones[i] ?? CharacterType.hole;
            if (BreakCharacter.notMovingCharacter(rowNotMove)) {
              row = {...row, j: rowNotMove};
            } else {
              CharacterType newUniqueCharacter =
                  CharacterGenerator.getUniqueRandomCharacter(boards, i, j);
              if (newLook.length > k) {
                // Draw remaining characters!!
                newUniqueCharacter = newLook[k];
                k++;
              }
              row = {...row, j: newUniqueCharacter};
            }
            boards[i] = row;
            currentPosition.add(PositionModel(row: i, col: j));
          }
        }
      }
      emit(state.copyWith(
          gameBoards: boards,
          dropDown: false,
          bombTouched: false,
          previousPosition: previousPosition,
      ));
    }
    Map<int, List<PositionModel>> connected = {};
    List<PositionModel> firstMoves = [];
    for (int i = 1; i <= state.row; i++) {
      for (int j = 1; j <= state.col; j++) {
        CharacterType type = getBoardCharacter(boards, row: i, col: j);
        if (!BreakCharacter.staticCharacterNeverChange(type)) {
          connected = getConnectedCharacter(state, i, j, type);
          if (connected.isNotEmpty) {
            if (connected.entries.first.key > 1) {
              firstMoves = [...connected.entries.first.value];
            }
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

    if (firstMoves.length <= 2) {
      emit(
        state.copyWith(
          checkHasNextMove: !state.checkHasNextMove,
          toBreak: [],
          planes: [],
          bulletVerticals: [],
          bulletHorizontals: [],
          bombs: [],
          superBombs: [],
          gameBoards: boards,
          dropDown: false,
          bombTouched: false,
          previousPosition: previousPosition,
        ),
      );
    }
  }
}
