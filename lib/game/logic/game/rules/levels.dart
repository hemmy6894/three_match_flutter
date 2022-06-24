part of '../game_bloc.dart';

class GameLevels {
  static startGame(Emitter<GameState> emit, GameState state, GameStartEvent event) async{
    Map<String, dynamic> level1 = Assets.levels[event.levelName];
    int col = level1["col"];
    int row = level1["row"];

    Map<int, Map<int, CharacterType>> gameBoards = {};
    final Map<int, Map<int, bool>> carpets = level1["carpet"] ?? {};
    var target = level1["targets"];
    List<Map<CharacterType, int>> targets = [];
    if (target.isNotEmpty) {
      targets = target;
    }

    var reward = level1["rewards"];
    List<RewardModel> rewards = [];
    if (reward.isNotEmpty) {
      rewards = reward;
    }

    final int moves = level1["moves"];
    gameBoards = drawBoard(level: event.levelName);
    emit(
      state.copyWith(
        gameBoards: gameBoards,
        col: col,
        row: row,
        carpets: carpets,
        targets: targets,
        moves: moves,
        rewards: rewards,
        level: event.levelName,
        assignedId: event.assignId
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    List<Map<CharacterType,PositionModel>> replaces = getSelectedBoosters(state, row: row,col: col);
    for(Map<CharacterType,PositionModel> rep in replaces) {
      gameBoards = BreakCharacter.replaceCharacterWith(
          emit, state, gameBoards, [rep.entries.first.value], rep.entries.first.key);
    }
    emit(
      state.copyWith(
          gameBoards: gameBoards,
          col: col,
          row: row,
          carpets: carpets,
          targets: targets,
          moves: moves,
          rewards: rewards,
          clearSelectedBooster: !state.clearSelectedBooster,
          level: event.levelName,
          assignedId: event.assignId
      ),
    );
  }

  static List<Map<CharacterType,PositionModel>> getSelectedBoosters(GameState state,{int row = 0, int col = 0}){
    List<Map<CharacterType,PositionModel>> replaces = [];
    List<PositionModel> possibilities = [];
    for (int i = 1; i <= row; i++) {
      for (int j = 1; j <= col; j++) {
        possibilities.add(PositionModel(row: i, col: j));
      }
    }
    List<Map<CharacterType,int>> starts = state.startWith;
    var rng = Random();
    for(Map<CharacterType,int> start in starts){
      for(int i = start.entries.first.value; i > 0; i--) {
        int position = rng.nextInt(possibilities.length);
        PositionModel pos = possibilities[position];
        possibilities.removeAt(position);
        replaces.add({start.entries.first.key: pos});
      }
    }
    return replaces;
  }
  static Map<int, Map<int, CharacterType>> drawBoard(
      {required int level, bool restart = false}) {
    Map<String, dynamic> level1 = Assets.levels[level];
    List<dynamic> boards = level1["board"];
    int col = level1["col"];
    int row = level1["row"];
    final Map<int, Map<int, CharacterType>> gameBoards = {};
    if (restart) {
      for (int i = 1; i <= row; i++) {
        Map<int, CharacterType> gameBoard = {};
        for (int j = 1; j <= col; j++) {
          CharacterType characterType = CharacterType.hole;
          gameBoard.addAll({j: characterType});
          gameBoards.addAll({i: gameBoard});
        }
      }
      return gameBoards;
    }
    for (int i = 1; i <= row; i++) {
      Map<int, CharacterType> gameBoard = {};
      for (int j = 1; j <= col; j++) {
        CharacterType characterType =
            boards[i - 1][j - 1] ?? CharacterType.hole;
        CharacterType randCharacter = CharacterGenerator.getUniqueRandomCharacter(gameBoards, i, j);
        if (BreakCharacter.noneBreakableCharacter(characterType)) {
          gameBoard.addAll({j: characterType});
          gameBoards.addAll({i: gameBoard});
        } else {
          gameBoard.addAll({j: randCharacter});
          gameBoards.addAll({i: gameBoard});
        }
      }
    }
    return gameBoards;
  }
}
