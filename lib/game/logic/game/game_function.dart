part of 'game_bloc.dart';

characterClicked(Emitter<GameState> emit, GameState state, int row, int col) {
  CharacterType g = getCharacter(state, row: row, col: col);
  if (g == CharacterType.hole) {
    emit(state);
    return;
  }
  if (state.firstClicked.isEmpty) {
    emit(state.copyWith(
        firstClicked: {row: col},
        tempClicked: {row: col},
        reversed: false,
        bombTouched: true));
    return;
  }
  state = state.copyWith(
      secondClicked: {row: col},
      tempSecClicked: {row: col},
      reversed: Helpers.isHandCaptured(state),
      selectedHelper: Helpers.isHandCaptured(state)
          ? CharacterType.hole
          : state.selectedHelper,
      bombTouched: true);

  emit(state);
}

clearClick(Emitter<GameState> emit, GameState state) {
  emit(state.copyWith(firstClicked: {}, secondClicked: {}));
}

CharacterType getCharacter(GameState state,
    {required int row, required int col}) {
  return state.gameBoards[row]?[col] ?? CharacterType.hole;
}

CharacterType getBoardCharacter(Map<int, Map<int, CharacterType>> gameBoards,
    {required int row, required int col}) {
  if (gameBoards.isEmpty) {
    return CharacterType.space;
  }
  return gameBoards[row]?[col] ?? CharacterType.space;
}

matchCharacter(Emitter<GameState> emit, GameState state) async {
  await checkConnected(emit, state);
}

checkConnected(Emitter<GameState> emit, GameState state) async {
  List<Map<int, int>> game = [];
  List<Map<int, int>> plane = [];
  List<Map<int, int>> bullet = [];
  List<Map<int, int>> bomb = [];
  List<Map<int, int>> superBomb = [];
  Map<int, List<Map<int, int>>> result = {};
  Map<int, List<Map<int, int>>> bombing = {};
  int matchCount = 0;

  List<Map<int, int>> game2 = [];
  List<Map<int, int>> plane2 = [];
  List<Map<int, int>> bullet2 = [];
  List<Map<int, int>> bomb2 = [];
  List<Map<int, int>> superBomb2 = [];
  Map<int, List<Map<int, int>>> result2 = {};
  Map<int, List<Map<int, int>>> bombing2 = {};
  int matchCount2 = 0;

  int total = 0;
  if (state.tempClicked.isNotEmpty) {
    int row = state.tempClicked.entries.first.key;
    int col = state.tempClicked.entries.first.value;
    CharacterType type = getCharacter(state, row: row, col: col);
    result = getConnectedCharacter(state, row, col, type);
    bombing = bombMoves(state, row, col);
    if (result.isNotEmpty) {
      matchCount = result.entries.first.key;
      game = result.entries.first.value;
    }
    if (bombing.isNotEmpty) {
      matchCount += bombing.entries.first.key;
      if (bombing.entries.first.key > 1) {
        print("BOOOO 1");
        game = [...game, ...bombing.entries.first.value];
      }
    }
    try {
      plane = result.entries.elementAt(1).value;
    } catch (e) {
      print(e);
    }
    try {
      bullet = result.entries.elementAt(2).value;
    } catch (e) {
      print(e);
    }
    try {
      bomb = result.entries.elementAt(3).value;
    } catch (e) {
      print(e);
    }
    try {
      superBomb = result.entries.elementAt(4).value;
    } catch (e) {
      print(e);
    }
  }

  if (state.tempSecClicked.isNotEmpty) {
    int row = state.tempSecClicked.entries.first.key;
    int col = state.tempSecClicked.entries.first.value;
    CharacterType type = getCharacter(state, row: row, col: col);
    result2 = getConnectedCharacter(state, row, col, type);
    bombing2 = bombMoves(state, row, col);
    if (result2.isNotEmpty) {
      matchCount2 = result2.entries.first.key;
      game2 = result2.entries.first.value;
    }
    if (bombing2.isNotEmpty) {
      matchCount2 += bombing2.entries.first.key;
      if (bombing2.entries.first.key > 1) {
        print("BOOOO");
        game2 = [...game2, ...bombing2.entries.first.value];
      }
    }
    try {
      plane2 = result2.entries.elementAt(1).value;
    } catch (e) {
      print(e);
    }
    try {
      bullet2 = result2.entries.elementAt(2).value;
    } catch (e) {
      print(e);
    }
    try {
      bomb2 = result2.entries.elementAt(3).value;
    } catch (e) {
      print(e);
    }
    try {
      superBomb2 = result2.entries.elementAt(4).value;
    } catch (e) {
      print(e);
    }
  }

  total = matchCount2 + matchCount;
  state = Helpers.isCaptured(emit, state) ?? state;
  print("Hand reserved ${state.reversed}");
  if (total < 1 && !state.reversed) {
    await Future.delayed(const Duration(seconds: 1));
    emit(
      state.copyWith(
        firstClicked: state.tempSecClicked,
        secondClicked: state.tempClicked,
        reversed: true,
        toBreak: [],
      ),
    );
  } else {
    emit(
      state.copyWith(
        toBreak: [...game2, ...game],
        planes: [...plane, ...plane2],
        bullets: [...bullet, ...bullet2],
        bombs: [...bomb, ...bomb2],
        superBombs: [...superBomb, ...superBomb2],
      ),
    );
  }
}

Map<int, List<Map<int, int>>> bombMoves(GameState state, int row, int col) {
  List<Map<int, int>> firstMoves = [];
  List<Map<int, int>> bombMoves = [];
  int matchCount = 0;
  bool moved = false;
  CharacterType block = getCharacter(state, row: row, col: col);
  if (block == CharacterType.horizontalBullet) {
    moved = false;
    for (int h = state.row; h >= 1; h--) {
      bombMoves.add({h: col});
      moved = true;
    }
    if (moved) {
      firstMoves = [...firstMoves, ...bombMoves];
      matchCount = 3;
    }
  }
  if (block == CharacterType.verticalBullet) {
    moved = false;
    for (int v = state.col; v >= 1; v--) {
      bombMoves.add({row: v});
      moved = true;
    }
    if (moved) {
      firstMoves = [...firstMoves, ...bombMoves];
      matchCount = 3;
    }
  }

  if (block == CharacterType.bomb) {
    moved = false;
    for (int h = (row + 1);
        h >= (row - 1) && (row >= 1 && row <= state.row);
        h--) {
      for (int v = (col + 1);
          v >= (col - 1) && (col >= 1 && row <= state.col);
          v--) {
        bombMoves.add({h: v});
        moved = true;
      }
    }
    if (moved) {
      firstMoves = [...firstMoves, ...bombMoves];
      matchCount = 3;
    }
  }

  if (block == CharacterType.superBomb) {
    moved = false;
    for (int h = (row + 2);
        h >= (row - 2) && (row >= 1 && row <= state.row);
        h--) {
      for (int v = (col + 2);
          v >= (col - 2) && (col >= 1 && row <= state.col);
          v--) {
        bombMoves.add({h: v});
        moved = true;
      }
    }
    if (moved) {
      firstMoves = [...firstMoves, ...bombMoves];
      matchCount = 3;
    }
  }
  return {matchCount: firstMoves};
}

Map<int, List<Map<int, int>>> getConnectedCharacter(
    GameState state, int row, int col, CharacterType type) {
  if (row > state.row || row <= 0 || col > state.col || col <= 0) {
    return {0: []};
  }
  int matchCount = 0;
  late CharacterType block;
  List<Map<int, int>> planes = [];
  List<Map<int, int>> bullets = [];
  List<Map<int, int>> bombs = [];
  List<Map<int, int>> superBombs = [];

  List<Map<int, int>> firstMoves = [];
  List<Map<int, int>> verticalMoves = [];
  List<Map<int, int>> horizontalMoves = [];
  //MOVED DOWN
  block = getCharacter(state, row: row, col: col);
  firstMoves.add({row: col});

  int colCount = 1;
  int rowCount = 1;
  int cc = 0;
  for (int i = (row + 1); i <= state.row; i++) {
    block = getCharacter(state, row: i, col: col);
    if (block == type) {
      rowCount++;
      cc++;
      verticalMoves.add({i: col});
    } else {
      break;
    }
  }
  for (int i = (row - 1); i >= 1; i--) {
    block = getCharacter(state, row: i, col: col);
    if (block == type) {
      verticalMoves.add({i: col});
      rowCount++;
    } else {
      break;
    }
  }
  for (int i = (col + 1); i <= state.col; i++) {
    block = getCharacter(state, row: row, col: i);
    if (block == type) {
      horizontalMoves.add({row: i});
      colCount++;
    } else {
      break;
    }
  }
  for (int i = (col - 1); i >= 1; i--) {
    block = getCharacter(state, row: row, col: i);
    if (block == type) {
      horizontalMoves.add({row: i});
      colCount++;
    } else {
      break;
    }
  }

  if (colCount > 2 || rowCount > 2) {
    matchCount = 3;
    firstMoves = [...firstMoves, ...horizontalMoves, ...verticalMoves];
    List<dynamic> bullet = SpecialCharacter.checkBullets(
        horizontalMoves, verticalMoves, {row: col});
    if (bullet.isNotEmpty) {
      bullets.add({row: col});
    }
    List<dynamic> bomb =
        SpecialCharacter.checkBombs(horizontalMoves, verticalMoves, {row: col});
    if (bomb.isNotEmpty) {
      bombs.add({row: col});
    }
    List<dynamic> superBomb = SpecialCharacter.checkSuperBombs(
        horizontalMoves, verticalMoves, {row: col});
    if (superBomb.isNotEmpty) {
      superBombs.add({row: col});
    }
  } else {
    matchCount = 0;
    firstMoves = [];
  }

  if (horizontalMoves.isNotEmpty && verticalMoves.isNotEmpty) {
    List<dynamic> jet = SpecialCharacter.checkPlane(
        state, horizontalMoves, verticalMoves, {row: col});
    if (jet.length >= 4) {
      planes.add({row: col});
      firstMoves = [...firstMoves, ...jet];
      matchCount = 4;
    }
  }

  /// Bomb Moves
  ///

  return {
    matchCount: firstMoves,
    1501: planes,
    1502: bullets,
    1503: bombs,
    1504: superBombs
  };
}

checkTopCharacter(Emitter<GameState> emit, GameState state,
    Map<int, Map<int, CharacterType>> boards, int row, int col) {
  for (int i = row; i >= 1; i--) {
    Map<int, CharacterType> rowC = boards[i] ?? {};
    if (rowC[col] != CharacterType.hole) {
      return rowC[col];
    } else {
      return checkTopCharacter(emit, state, boards, (i - 1), col);
    }
  }
  return CharacterGenerator.getUniqueRandomCharacter(boards, row, col);
}

changeRow(
    {required int rowCount,
    required int from,
    required int to,
    required Map<int, CharacterType> row}) {
  Map<int, CharacterType> newRow = row;
  print("ROW " +
      rowCount.toString() +
      " FROM " +
      from.toString() +
      " TO " +
      to.toString());
  for (int x = from; x <= to; x++) {
    newRow = {...newRow, x: CharacterType.hole};
  }
  return newRow;
}

moveCharacter(Emitter<GameState> emit, GameState state) {
  if (state.firstClicked.isNotEmpty && state.secondClicked.isNotEmpty) {
    int firstRow = state.firstClicked.entries.first.key;
    int firstCol = state.firstClicked.entries.first.value;
    int secondRow = state.secondClicked.entries.first.key;
    int secondCol = state.secondClicked.entries.first.value;

    CharacterType firstCharacter =
        getCharacter(state, row: firstRow, col: firstCol);
    CharacterType secondCharacter =
        getCharacter(state, row: secondRow, col: secondCol);
    if (firstCharacter != CharacterType.hole &&
        secondCharacter != CharacterType.hole) {
      Map<int, Map<int, CharacterType>> gameBoards = state.gameBoards;
      if (firstRow == secondRow) {
        bool check = secondCol == (firstCol + 1) || secondCol == (firstCol - 1);
        if (check) {
          Map<int, CharacterType> rowBoard = gameBoards[firstRow] ?? {};
          Map<int, CharacterType> newRowBoard = {};
          if (rowBoard.isNotEmpty) {
            newRowBoard = {
              ...rowBoard,
              firstCol: secondCharacter,
              secondCol: firstCharacter
            };
            gameBoards.update(firstRow, (value) => newRowBoard);
            emit(state.copyWith(gameBoards: {...gameBoards}, match: true));
          }
        }
      }
      if (firstCol == secondCol) {
        bool check = secondRow == (firstRow + 1) || secondRow == (firstRow - 1);
        if (check) {
          Map<int, CharacterType> firstRowBoard = gameBoards[firstRow] ?? {};
          Map<int, CharacterType> secondRowBoard = gameBoards[secondRow] ?? {};
          Map<int, CharacterType> newFirstRowBoard = {};
          Map<int, CharacterType> newSecondRowBoard = {};
          if (firstRowBoard.isNotEmpty) {
            newFirstRowBoard = {...firstRowBoard, firstCol: secondCharacter};
            gameBoards.update(firstRow, (value) => newFirstRowBoard);
          }
          if (secondRowBoard.isNotEmpty) {
            newSecondRowBoard = {...secondRowBoard, secondCol: firstCharacter};
            gameBoards.update(secondRow, (value) => newSecondRowBoard);
          }
          emit(state.copyWith(gameBoards: {...gameBoards}, match: true));
        }
      }
    }
  }
}
