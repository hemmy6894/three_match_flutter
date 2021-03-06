part of 'game_bloc.dart';

characterClicked(Emitter<GameState> emit, GameState state, int row, int col) {
  CharacterType g = getCharacter(state, row: row, col: col);
  if (g == CharacterType.hole) {
    emit(state);
    return;
  }
  if (state.firstClicked.isEmpty) {
    emit(state.copyWith(
        firstClicked: PositionModel(row: row, col: col),
        tempClicked: PositionModel(row: row, col: col),
        reversed: false,
        bombTouched: true));
    return;
  }
  state = state.copyWith(
      secondClicked: PositionModel(row: row, col: col),
      tempSecClicked: PositionModel(row: row, col: col),
      reversed: Helpers.isHandCaptured(state),
      reduceHelperReward: state.selectedHelper,
      selectedHelper: Helpers.isHandCaptured(state) ? CharacterType.hole : state.selectedHelper,
      bombTouched: true);
  emit(state);
}

clearClick(Emitter<GameState> emit, GameState state) {
  emit(state.copyWith(firstClicked: state.firstClicked.clear, secondClicked: state.secondClicked.clear));
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
  List<PositionModel> game = [];
  List<PositionModel> plane = [];
  List<PositionModel> bulletH = [];
  List<PositionModel> bulletV = [];
  List<PositionModel> bomb = [];
  List<PositionModel> superBomb = [];
  Map<int, List<PositionModel>> result = {};
  Map<int, List<PositionModel>> bombing = {};
  int matchCount = 0;

  List<PositionModel> game2 = [];
  List<PositionModel> plane2 = [];
  List<PositionModel> bulletH2 = [];
  List<PositionModel> bulletV2 = [];
  List<PositionModel> bomb2 = [];
  List<PositionModel> superBomb2 = [];
  Map<int, List<PositionModel>> result2 = {};
  Map<int, List<PositionModel>> bombing2 = {};
  int matchCount2 = 0;

  int total = 0;
  if (state.tempClicked.isNotEmpty) {
    int row = state.tempClicked.row;
    int col = state.tempClicked.col;
    CharacterType type = getCharacter(state, row: row, col: col);
    result = getConnectedCharacter(state, row, col, type);
    bombing = await BombMove.bombMoves(emit,state, row, col);
    if (result.isNotEmpty) {
      matchCount = result.entries.first.key;
      game = result.entries.first.value;
    }
    if (bombing.isNotEmpty) {
      matchCount += bombing.entries.first.key;
      if (bombing.entries.first.key > 1) {
        game = [...game, ...bombing.entries.first.value];
      }
    }
    try {
      plane = result.entries.elementAt(1).value;
    } catch (e) {
      print(e);
    }
    try {
      bulletV = result.entries.elementAt(2).value;
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
    try {
      bulletH = result.entries.elementAt(5).value;
    } catch (e) {
      print(e);
    }
  }

  if (state.tempSecClicked.isNotEmpty) {
    int row = state.tempSecClicked.row;
    int col = state.tempSecClicked.col;
    CharacterType type = getCharacter(state, row: row, col: col);
    result2 = getConnectedCharacter(state, row, col, type);
    bombing2 = await  BombMove.bombMoves(emit,state, row, col);
    if (result2.isNotEmpty) {
      matchCount2 = result2.entries.first.key;
      game2 = result2.entries.first.value;
    }
    if (bombing2.isNotEmpty) {
      matchCount2 += bombing2.entries.first.key;
      if (bombing2.entries.first.key > 1) {
        game2 = [...game2, ...bombing2.entries.first.value];
      }
    }
    try {
      plane2 = result2.entries.elementAt(1).value;
    } catch (e) {
      print(e);
    }
    try {
      bulletV2 = result2.entries.elementAt(2).value;
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
    try {
      bulletH2 = result2.entries.elementAt(5).value;
    } catch (e) {
      print(e);
    }
  }

  total = matchCount2 + matchCount;
  state = Helpers.isCaptured(emit, state) ?? state;
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
        moves: !state.reversed ? (state.moves - 1) : state.moves, // if has moves and not reverse with all helpers!!
        toBreak: [...game2, ...game],
        planes: [...plane, ...plane2],
        bulletHorizontals: [...bulletH, ...bulletH2],
        bulletVerticals: [...bulletV, ...bulletV2],
        bombs: [...bomb, ...bomb2],
        superBombs: [...superBomb, ...superBomb2],
      ),
    );
  }
}

Map<int, List<PositionModel>> getConnectedCharacter(GameState state, int row, int col, CharacterType type, {int minus = 0}) { // minus only for checking purpose
  if (row > state.row || row <= 0 || col > state.col || col <= 0) {
    return {0: []};
  }
  if(BreakCharacter.staticCharacterNeverChange(type)){
    return {0: []};
  }
  if(BreakCharacter.noneBreakableCharacter(type)){
    return {0: []};
  }
  int matchCount = 0;
  late CharacterType block;
  List<PositionModel> planes = [];
  List<PositionModel> bulletVerticals = [];
  List<PositionModel> bulletHorizontals = [];
  List<PositionModel> bombs = [];
  List<PositionModel> superBombs = [];

  List<PositionModel> firstMoves = [];
  List<PositionModel> verticalMoves = [];
  List<PositionModel> horizontalMoves = [];
  //MOVED DOWN
  block = getCharacter(state, row: row - minus, col: col - minus);
  firstMoves.add(PositionModel(row: row, col: col));

  int colCount = 1;
  int rowCount = 1;
  int cc = 0;
  for (int i = (row + 1); i <= state.row; i++) {
    block = getCharacter(state, row: i, col: col);
    if (block == type) {
      rowCount++;
      cc++;
      verticalMoves.add(PositionModel(row: i, col: col));
    } else {
      break;
    }
  }
  for (int i = (row - 1); i >= 1; i--) {
    block = getCharacter(state, row: i, col: col);
    if (block == type) {
      verticalMoves.add(PositionModel(row: i, col: col));
      rowCount++;
    } else {
      break;
    }
  }
  for (int i = (col + 1); i <= state.col; i++) {
    block = getCharacter(state, row: row, col: i);
    if (block == type) {
      horizontalMoves.add(PositionModel(row: row, col: i));
      colCount++;
    } else {
      break;
    }
  }
  for (int i = (col - 1); i >= 1; i--) {
    block = getCharacter(state, row: row, col: i);
    if (block == type) {
      horizontalMoves.add(PositionModel(row: row, col: i));
      colCount++;
    } else {
      break;
    }
  }

  if (colCount > 2 || rowCount > 2) {
    matchCount = 3;
    firstMoves = [...firstMoves, ...horizontalMoves, ...verticalMoves];
    List<dynamic> bulletH = SpecialCharacter.checkBulletHorizontal(horizontalMoves, verticalMoves, {row: col});
    if (bulletH.isNotEmpty) {
      bulletHorizontals.add(PositionModel(row: row, col: col));
    }
    List<dynamic> bulletV = SpecialCharacter.checkBulletVertical(horizontalMoves, verticalMoves, {row: col});
    if (bulletV.isNotEmpty) {
      bulletVerticals.add(PositionModel(row: row, col: col));
    }
    List<dynamic> bomb = SpecialCharacter.checkBombs(horizontalMoves, verticalMoves, {row: col});
    if (bomb.isNotEmpty) {
      bombs.add(PositionModel(row: row, col: col));
    }
    List<dynamic> superBomb = SpecialCharacter.checkSuperBombs(horizontalMoves, verticalMoves, {row: col});
    if (superBomb.isNotEmpty) {
      superBombs.add(PositionModel(row: row, col: col));
    }
  } else {
    matchCount = 0;
    firstMoves = [];
  }

  if (horizontalMoves.isNotEmpty && verticalMoves.isNotEmpty) {
    List<dynamic> jet = SpecialCharacter.checkPlane(
        state, horizontalMoves, verticalMoves, PositionModel(row: row, col: col));
    if (jet.length >= 4) {
      planes.add(PositionModel(row: row, col: col));
      firstMoves = [...firstMoves, ...jet];
      matchCount = 4;
    }
  }

  /// Bomb Moves
  ///

  return {
    matchCount: firstMoves,
    1501: planes,
    1502: bulletVerticals,
    1503: bombs,
    1504: superBombs,
    1505: bulletHorizontals,
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
    int firstRow = state.firstClicked.row;
    int firstCol = state.firstClicked.col;
    int secondRow = state.secondClicked.row;
    int secondCol = state.secondClicked.col;
    CharacterType firstCharacter = getCharacter(state, row: firstRow, col: firstCol);
    CharacterType secondCharacter = getCharacter(state, row: secondRow, col: secondCol);
    if (firstCharacter != CharacterType.hole && secondCharacter != CharacterType.hole) {
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
        }else if(BreakCharacter.isBombCharacter(firstCharacter)){
          emit(state.copyWith(match: true));
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
        }else if(BreakCharacter.isBombCharacter(firstCharacter)){
          emit(state.copyWith(match: true));
        }
      }
    }
  }
}


clearBlast(Emitter<GameState> emit, GameState state,ClearBlastEvent event){
  emit(state.copyWith(superBombBlast: event.superBombBlast ?? state.superBombBlast));
}