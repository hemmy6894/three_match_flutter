part of '../game_bloc.dart';

class Helpers {
  static catchHelper(
      Emitter<GameState> emit, GameState state, CharacterType helper) async {
    if (helper == CharacterType.restart) {
      await Helpers.isRestartClicked(emit, state);
    } else {
      emit(state.copyWith(selectedHelper: helper));
    }
  }

  static isCaptured(Emitter<GameState> emit, GameState state) {
    if (state.selectedHelper == null) {
      return null;
    }
    if (state.selectedHelper == CharacterType.hummer) {
      Helpers.isHummerCaptured(emit, state);
    }
    if (state.selectedHelper == CharacterType.hand) {}
  }

  static isRestartClicked(Emitter<GameState> emit, GameState state) async {
    emit(
      state.copyWith(
        selectedHelper: null,
        gameBoards: GameLevels.drawBoard(level: state.level, restart: true),
      ),
    );

    await Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );

    emit(
      state.copyWith(
        selectedHelper: null,
        gameBoards: GameLevels.drawBoard(level: state.level),
      ),
    );
  }

  static isHandCaptured(GameState state) {
    return state.selectedHelper == CharacterType.hand;
  }

  static isHummerCaptured(Emitter<GameState> emit, GameState state) {
    Map<int, Map<int, CharacterType>> boards = state.gameBoards;
    if (state.firstClicked.isNotEmpty &&
        state.secondClicked.isEmpty &&
        state.selectedHelper == CharacterType.hummer) {
      int row = state.firstClicked.entries.first.key;
      int col = state.firstClicked.entries.first.value;
      Map<int, CharacterType> myRow = boards[row] ?? {};
      myRow = {...myRow, col: CharacterType.hole};
      boards = {...boards, row: myRow};

      emit(state.copyWith(
        gameBoards: boards,
        dropDown: true,
        selectedHelper: CharacterType.hole,
        firstClicked: {},
      ));
    }
  }

  static String getTimeInMinutes(int time) {
    return moreThan60(time);
  }

  static String moreThan60(int number) {
    List<int> numbers = [];
    // int n = number;
    int rem = number % 60;
    try {
      for (int n = number; n >= 60;) {
        n = (n ~/ 60);
        if (n > 59) {
          numbers.add(n % 60);
        } else {
          numbers.add(n);
        }
      }
    } catch (e) {
      print(e);
    }
    String re = "";
    for (int r in numbers.reversed) {
      re += (isLessThanTen(r).toString() + ":");
    }
    re = re + isLessThanTen(rem);
    return re;
  }

  static String isLessThanTen(int number) {
    if (number < 10) {
      return "0" + number.toString();
    }
    return number.toString();
  }
}
