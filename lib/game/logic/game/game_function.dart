part of 'game_bloc.dart';

List<CharacterType> chars = [
  CharacterType.banana,
  CharacterType.apple,
  CharacterType.pear,
  CharacterType.blueBerry,
  CharacterType.orange,
  CharacterType.hole,
  CharacterType.space,
  CharacterType.bomb,
  CharacterType.plane,
];

startGameLevel1(Emitter<GameState> emit, GameState state) {
  Map<String,dynamic> level1 = Assets.level1;
  state = state.copyWith(col: level1["col"], row:  level1["row"]);
  emit(state);
  int col = state.col;
  int row = state.row;

  final Map<int, Map<int, CharacterType>> gameBoards = {};
  for (int i = 1; i <= row; i++) {
    Map<int, CharacterType> gameBoard = {};
    for (int j = 1; j <= col; j++) {
      CharacterType randCharacter = getUniqueRandomCharacter(gameBoards, i, j);
      gameBoard.addAll({j: randCharacter});
      gameBoards.addAll({i: gameBoard});
    }
  }
  emit(state.copyWith(gameBoards: gameBoards));
}

getUniqueRandomCharacter(gameBoards, row, col) {
  var rng = Random();
  CharacterType randCharacter = chars[rng.nextInt(4)];
  CharacterType twoRowBeforeCharacter =
      getBoardCharacter(gameBoards, row: (row - 2), col: col);
  CharacterType twoColBeforeCharacter =
      getBoardCharacter(gameBoards, row: row, col: (col - 2));
  if (randCharacter == twoColBeforeCharacter ||
      randCharacter == twoRowBeforeCharacter) {
    randCharacter = getUniqueRandomCharacter(gameBoards, row, col);
  }
  return randCharacter;
}

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
      reversed: false,
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
      if(bombing.entries.first.key > 1) {
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
      if(bombing2.entries.first.key > 1) {
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

Map<int, List<Map<int,int>>> bombMoves(GameState state, int row, int col) {
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
    List<dynamic> bullet =
        checkBullets(horizontalMoves, verticalMoves, {row: col});
    if (bullet.isNotEmpty) {
      bullets.add({row: col});
    }
    List<dynamic> bomb = checkBombs(horizontalMoves, verticalMoves, {row: col});
    if (bomb.isNotEmpty) {
      bombs.add({row: col});
    }
    List<dynamic> superBomb =
        checkSuperBombs(horizontalMoves, verticalMoves, {row: col});
    if (superBomb.isNotEmpty) {
      superBombs.add({row: col});
    }
  } else {
    matchCount = 0;
    firstMoves = [];
  }

  if (horizontalMoves.isNotEmpty && verticalMoves.isNotEmpty) {
    List<dynamic> jet =
        checkPlane(state, horizontalMoves, verticalMoves, {row: col});
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

checkPlane(GameState state, List<Map<int, int>> horizontal,
    List<Map<int, int>> vertical, Map<int, int> current) {
  if (horizontal.isNotEmpty && vertical.isNotEmpty) {
    if (current.isNotEmpty) {
      int horizontalRow = horizontal[0].entries.first.key;
      int horizontalCol = horizontal[0].entries.first.value;

      int verticalRow = vertical[0].entries.first.key;
      int verticalCol = vertical[0].entries.first.value;

      int currentRow = current.entries.first.key;
      int currentCol = current.entries.first.value;

      int newCol = 0, newRow = 0;
      if (currentRow == horizontalRow && currentCol == verticalCol) {
        if (verticalRow - 1 == currentRow) {
          if (horizontalCol - 1 == currentCol) {
            newCol = currentCol + 1;
            newRow = verticalRow;
          }
          if (horizontalCol + 1 == currentCol) {
            newCol = currentCol - 1;
            newRow = verticalRow;
          }
        }
        if (verticalRow + 1 == currentRow) {
          if (horizontalCol - 1 == currentCol) {
            newCol = currentCol + 1;
            newRow = verticalRow;
          }
          if (horizontalCol + 1 == currentCol) {
            newCol = currentCol - 1;
            newRow = verticalRow;
          }
        }
      }
      if (newCol != 0 && newRow != 0) {
        CharacterType target = getCharacter(state, row: newRow, col: newCol);
        CharacterType main =
            getCharacter(state, row: currentRow, col: currentCol);
        if (main == target) {
          return [
            horizontal[0],
            vertical[0],
            current,
            {newRow: newCol}
          ];
        }
      }
    }
  }
  return [];
}

checkBullets(List<Map<int, int>> horizontal, List<Map<int, int>> vertical,
    Map<int, int> current) {
  if (horizontal.length == 3 || vertical.length == 3) {
    return [current];
  }
  return [];
}

checkBombs(List<Map<int, int>> horizontal, List<Map<int, int>> vertical,
    Map<int, int> current) {
  if (horizontal.length == 2 && vertical.length == 2) {
    return [current];
  }
  return [];
}

checkSuperBombs(List<Map<int, int>> horizontal, List<Map<int, int>> vertical,
    Map<int, int> current) {
  if (horizontal.length >= 4 || vertical.length >= 4) {
    return [current];
  }
  return [];
}

CharacterType getBullet() {
  var rand = Random();
  return rand.nextInt(1000) % 2 == 0
      ? CharacterType.verticalBullet
      : CharacterType.horizontalBullet;
}

breakMatch(Emitter<GameState> emit, GameState state) {
  Map<int, Map<int, CharacterType>> boards = state.gameBoards;
  boards = replaceCharacterWith(boards, state.planes, CharacterType.plane);
  boards = replaceCharacterWith(boards, state.bullets, getBullet());
  boards = replaceCharacterWith(boards, state.bombs, CharacterType.bomb);
  boards =
      replaceCharacterWith(boards, state.superBombs, CharacterType.superBomb);

  List<Map<int, int>> remains = [];
  remains = removeIfMatchForBomb(state.planes, state.toBreak);
  remains = removeIfMatchForBomb(state.bombs, remains);
  remains = removeIfMatchForBomb(state.bullets, remains);
  remains = removeIfMatchForBomb(state.superBombs, remains);

  boards = replaceCharacterWith(boards, remains, CharacterType.hole);

  emit(state.copyWith(
      gameBoards: boards,
      dropDown: true,
      toBreak: [],
      planes: [],
      bullets: [],
      bombs: [],
      superBombs: []));
}

Map<int, Map<int, CharacterType>> replaceCharacterWith(
    Map<int, Map<int, CharacterType>> boards,
    List<Map<int, int>> replaces,
    CharacterType character) {
  Map<int, Map<int, CharacterType>> bds = boards;
  for (Map<int, int> replace in replaces) {
    int rowCount = replace.entries.first.key;
    int colCount = replace.entries.first.value;
    Map<int, CharacterType> row = bds[rowCount] ?? {};
    row[colCount] = character;
    bds[rowCount] = row;
  }
  return bds;
}

List<Map<int, int>> removeIfMatchForBomb(
    List<Map<int, int>> bombs, List<Map<int, int>> breaks) {
  List<Map<int, int>> remains = [];
  if (bombs.isNotEmpty) {
    bool exist = false;
    for (Map<int, int> brk in breaks) {
      exist = false;
      for (Map<int, int> bom in bombs) {
        if (mapEquals(brk, bom)) {
          exist = true;
        }
      }
      if (!exist) {
        remains.add(brk);
      }
    }
  } else {
    remains = breaks;
  }
  return remains;
}

dropCharacter(Emitter<GameState> emit, GameState state) async {
  Map<int, Map<int, CharacterType>> boards = state.gameBoards;
  final List<Map<int, int>> previousPosition = [];
  final List<Map<int, int>> currentPosition = [];
  if (state.dropDown) {
    int lessBy = 0;
    // print("DROP");
    for (int j = 1; j <= state.col; j++) {
      int colIncrement = 0;
      List<CharacterType> newLook = [];
      for (int i = state.row; i >= 1; i--) {
        // List all character in column which is not hole
        CharacterType character = boards[i]?[j] ?? CharacterType.hole;
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
          row = {...row, j: getUniqueRandomCharacter(boards, i, j)};
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
          firstMoves = [...firstMoves, ...connected.entries.first.value];
        }
      }
    }
  }
  if (firstMoves.length > 2) {
    emit(
      state.copyWith(
        toBreak: firstMoves,
        planes: [],
        bullets: [],
        bombs: [],
        superBombs: [],
      ),
    );
  }
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
  return getUniqueRandomCharacter(boards, row, col);
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
