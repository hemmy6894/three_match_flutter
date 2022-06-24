part of '../game_bloc.dart';

class BombMove {
  static Future<Map<int, List<PositionModel>>> bombMoves(
      Emitter<GameState> emit, GameState state, int row, int col,
      {bool recheck = false}) async {
    List<PositionModel> firstMoves = [];
    int matchCount = 0;
    CharacterType block = getCharacter(state, row: row, col: col);
    if (BreakCharacter.staticCharacterNeverChange(block)) {
      return {0: []};
    }
    if (block == CharacterType.plane) {
      List<dynamic> planeMove = planeMoves(row, col, state);
      if (planeMove.isNotEmpty) {
        firstMoves = [...firstMoves, ...planeMove];
        matchCount = 3;
      }
    }
    if (block == CharacterType.verticalBullet) {
      List<dynamic> verticals = verticalMoves(state.row, col, state);
      if (verticals.isNotEmpty) {
        firstMoves = [...firstMoves, ...verticals];
        matchCount = 3;
      }
    }
    if (block == CharacterType.horizontalBullet) {
      List<PositionModel> horizontals = horizontalMoves(row, state.col, state);
      if (horizontals.isNotEmpty) {
        firstMoves = [...firstMoves, ...horizontals];
        matchCount = 3;
      }
    }

    if (block == CharacterType.bomb) {
      List<dynamic> bombs = bombMove(row, col, state);
      if (bombs.isNotEmpty) {
        firstMoves = [...firstMoves, ...bombs];
        matchCount = 3;
      }
    }

    if (block == CharacterType.superBomb) {
      List<dynamic> superBombs = await superBombMove(row, col, emit, state, recheck: recheck);
      if (superBombs.isNotEmpty) {
        firstMoves = [...firstMoves, ...superBombs];
        matchCount = 3;
      }
    }
    if (!recheck) {
      firstMoves = await recheckMoves(emit, state, firstMoves);
    }
    return {matchCount: firstMoves};
  }

  static Future<List<PositionModel>> recheckMoves(Emitter<GameState> emit, GameState state,
      List<PositionModel> firstMoves) async {
    for (PositionModel fm in firstMoves) {
      if (BreakCharacter.isBombCharacter(getCharacter(state,
          row: fm.row, col: fm.col))) {
        Map<int, List<PositionModel>> bo = await bombMoves(
            emit, state, fm.row, fm.col,
            recheck: true);
        if (bo.isNotEmpty) {
          if (bo.entries.first.key > 1) {
            firstMoves = [...firstMoves, ...bo.entries.first.value];
          }
        }
      }
    }
    return firstMoves;
  }

  static Future<List<PositionModel>> superBombMove(
      int row, int col, Emitter<GameState> emit, GameState state,
      {bool recheck = false}) async {
    bool move = true;
    List<PositionModel> mvs = [];
    CharacterType firstCharacter = CharacterType.hole;
    CharacterType secCharacter = CharacterType.hole;
    CharacterType thirdCharacter = getCharacter(state, row: row, col: col);

    int rowFirst = 0, rowSec = 0, colFirst = 0, colSec = 0;
    if (state.tempClicked.isNotEmpty) {
      rowFirst = state.tempClicked.row;
      colFirst = state.tempClicked.col;
      firstCharacter = getCharacter(state, row: rowFirst, col: colFirst);
    }
    if (state.tempSecClicked.isNotEmpty) {
      rowSec = state.tempSecClicked.row;
      colSec = state.tempSecClicked.col;
      secCharacter = getCharacter(state, row: rowSec, col: colSec);
    }
    if (state.tempSecClicked == state.tempClicked) {
      // Does not allow double click
      move = false;
    } else if (firstCharacter == CharacterType.superBomb &&
        !BreakCharacter.isBombCharacter(secCharacter)) {
      mvs.add(PositionModel(row: row, col: col));
      for (PositionModel bm in findMatchedCharacter(state, secCharacter)) {
        mvs.add(bm);
      }
    } else if (secCharacter == CharacterType.superBomb &&
        !BreakCharacter.isBombCharacter(firstCharacter)) {
      mvs.add(PositionModel(row: row, col: col));
      for (PositionModel bm in findMatchedCharacter(state, firstCharacter)) {
        mvs.add(bm);
      }
    } else if (secCharacter == CharacterType.superBomb &&
        firstCharacter == CharacterType.superBomb) {
      for (int row = state.row; row >= 1; row--) {
        for (int col = state.col; col >= 1; col--) {
          mvs.add(PositionModel(row: row, col: col));
        }
      }
    } else if (thirdCharacter == CharacterType.superBomb &&
        BreakCharacter.isBombCharacter(secCharacter)) {
      mvs = await breakSuperBombIfConnectedWithBombOrFoundOnBomb(
          emit,
          state,
          secCharacter == CharacterType.superBomb
              ? firstCharacter
              : secCharacter,
          mvs);
    } else if (thirdCharacter == CharacterType.superBomb &&
        BreakCharacter.isBombCharacter(firstCharacter)) {
      mvs = await breakSuperBombIfConnectedWithBombOrFoundOnBomb(
          emit,
          state,
          secCharacter == CharacterType.superBomb
              ? firstCharacter
              : secCharacter,
          mvs);
    } else {
      move = false;
    }
    if (move) {
      return mvs;
    }
    return mvs;
  }

  static Future<List<PositionModel>> breakSuperBombIfConnectedWithBombOrFoundOnBomb(Emitter<GameState> emit,
      GameState state, CharacterType replace, List<PositionModel> mvs,
      {bool recheck = false}) async {
    PositionModel randomCharacterToPutBomb =
        findRandomCharacterOnBoards(state, []);
    List<PositionModel> matches = findMatchedCharacter(
        state,
        getCharacter(state,
            row: randomCharacterToPutBomb.row,
            col: randomCharacterToPutBomb.col));
    if (recheck) {
      for (PositionModel match in matches) {
        mvs.add(match);
      }
    } else {
      Map<int, Map<int, CharacterType>> boards =
          BreakCharacter.replaceCharacterWith(
              emit, state, state.gameBoards, matches, replace);
      emit(state.copyWith(gameBoards: boards));
      await Future.delayed(const Duration(milliseconds: 500));
      for (PositionModel match in await recheckMoves(emit, state, matches)) {
        mvs.add(match);
      }
    }
    return mvs;
  }

  static List<PositionModel> bombMove(int row, int col, GameState state, {bool manual = false}) {
    PositionModel reserve = PositionModel.empty();
    if (PositionModel(row: row,col: col)  == state.tempClicked) {
      reserve = state.tempSecClicked;
    } else if ( PositionModel(row: row,col: col)  == state.tempSecClicked) {
      reserve = state.tempClicked;
    }else{
      if(getCharacter(state, row: state.tempClicked.row, col: state.tempClicked.row) == CharacterType.bomb){
        reserve = state.tempSecClicked;
      }else{
        reserve = state.tempClicked;
      }
    }
    CharacterType bomb = CharacterType.hole;
    if (reserve.isNotEmpty) {
      bomb = getCharacter(state, row: reserve.row, col: reserve.row);
    }
    if(bomb == CharacterType.plane && !manual){
      return [];
    }
    if(bomb == CharacterType.bomb && !manual && (getCharacter(state, row: state.tempClicked.row, col: state.tempClicked.col) != getCharacter(state, row: state.tempSecClicked.row, col: state.tempSecClicked.col))){
      return [];
    }
    bool move = false;
    List<PositionModel> mvs = [];

    if (bomb == CharacterType.verticalBullet || bomb == CharacterType.horizontalBullet) {
      for (int v = state.col; v >= 1; v--) {
        mvs.add(PositionModel(row: row-1, col: v));
        mvs.add(PositionModel(row: row, col: v));
        mvs.add(PositionModel(row: row+1, col: v));
      }
      for (int h = state.row; h >= 1; h--) {
        mvs.add(PositionModel(row: h, col: col+1));
        mvs.add(PositionModel(row: h, col: col));
        mvs.add(PositionModel(row: h, col: col-1));
      }
    }else if (bomb == CharacterType.bomb) {
      for (int h = (row + 2); h >= (row - 2); h--) {
        for (int v = (col + 2); v >= (col - 2); v--) {
          mvs.add(PositionModel(row: h, col: v));
          move = true;
        }
      }
    }else{
      for (int h = (row + 1); h >= (row - 1); h--) {
        for (int v = (col + 1); v >= (col - 1); v--) {
          mvs.add(PositionModel(row: h, col: v));
          move = true;
        }
      }
    }
    if (move) {
      return mvs;
    }
    return mvs;
  }

  static List<PositionModel> verticalMoves(int row, int col, GameState state,
      {bool manual = false}) {
    PositionModel reserve = PositionModel.empty();
    if (PositionModel(row: row,col: col) == state.tempClicked) {
      reserve = state.tempSecClicked;
    } else if (PositionModel(row: row,col: col) == state.tempSecClicked) {
      reserve = state.tempClicked;
    }else{
      if(getCharacter(state, row: state.tempClicked.row, col: state.tempClicked.col) == CharacterType.verticalBullet){
        reserve = state.tempSecClicked;
      }else{
        reserve = state.tempClicked;
      }
    }
    CharacterType bomb = CharacterType.hole;
    if (reserve.isNotEmpty) {
      bomb = getCharacter(state, row: reserve.row, col: reserve.col);
    }
    if(bomb == CharacterType.plane && !manual){
      return [];
    }
    if(bomb == CharacterType.bomb && !manual){
      return [];
    }
    bool move = false;
    List<PositionModel> mvs = [];
    for (int h = state.row; h >= 1; h--) {
      mvs.add(PositionModel(row: h, col: col));
      move = true;
    }
    //Same bomb
    if(bomb == CharacterType.verticalBullet && !manual){
      for (int h = state.col; h >= 1; h--) {
        mvs.add(PositionModel(row: reserve.row, col: h));
        move = true;
      }
    }
    if (move) {
      return mvs;
    }
    return mvs;
  }

  static List<PositionModel> horizontalMoves(int row, int col, GameState state,
      {bool manual = false}) {
    PositionModel reserve = PositionModel.empty();
    CharacterType bomb = CharacterType.hole;
    if (PositionModel(row: row,col: col) == state.tempClicked) {
      reserve = state.tempSecClicked;
    } else if (PositionModel(row: row,col: col) == state.tempSecClicked) {
      reserve = state.tempClicked;
    }else{
      if(getCharacter(state, row: state.tempClicked.row, col: state.tempClicked.row) == CharacterType.horizontalBullet){
        reserve = state.tempSecClicked;
      }else{
        reserve = state.tempClicked;
      }
    }
    if (reserve.isNotEmpty) {
      bomb = getCharacter(state, row: reserve.row, col: reserve.col);
    }
    if(bomb == CharacterType.plane && !manual){
      return [];
    }
    if(bomb == CharacterType.bomb && !manual){
      return [];
    }
    bool move = false;
    List<PositionModel> mvs = [];
    for (int v = state.col; v >= 1; v--) {
      mvs.add(PositionModel(row: row, col: v));
      move = true;
    }
    //Same bomb
    if(bomb == CharacterType.horizontalBullet && !manual){
      for (int h = state.row; h >= 1; h--) {
        mvs.add(PositionModel(row: h, col: reserve.col));
        move = true;
      }
    }
    if (move) {
      return mvs;
    }
    return mvs;
  }

  static List<PositionModel> planeMoves(int row, int col, GameState state, {bool manual = false}) {
    List<PositionModel> mvs = [];
    CharacterType firstCharacter = CharacterType.hole;
    firstCharacter = getCharacter(state, row: row, col: col);
    PositionModel reserve = PositionModel.empty();
    CharacterType bomb = CharacterType.hole;
    if (PositionModel(row: row,col: col) == state.tempClicked) {
      reserve = state.tempSecClicked;
    } else if (PositionModel(row: row,col: col) == state.tempSecClicked) {
      reserve = state.tempClicked;
    }else{
      if(getCharacter(state, row: state.tempClicked.row, col: state.tempClicked.col) == CharacterType.plane){
        reserve = state.tempSecClicked;
      }else{
        reserve = state.tempClicked;
      }
    }
    if (reserve.isNotEmpty) {
      bomb = getCharacter(state, row: reserve.row, col: reserve.col);
    }
    if(bomb == CharacterType.plane && !manual && (getCharacter(state, row: state.tempClicked.row, col: state.tempClicked.col) != getCharacter(state, row: state.tempSecClicked.row, col: state.tempSecClicked.col))){
      return [];
    }
    // TODO: This called twice due to bomb moves called twice so you must check if is already called before recall
    if (firstCharacter == CharacterType.plane) {
      mvs.add(PositionModel(row: row, col: col));
      mvs.add(PositionModel(row: row, col: col+1));
      mvs.add(PositionModel(row: row, col: col-1));
      mvs.add(PositionModel(row: row+1, col: col));
      mvs.add(PositionModel(row: row-1, col: col));
      if (BreakCharacter.isBombCharacter(bomb)) {
        PositionModel bombTargets = findTargetOnBoards(state, mvs);
        if (bombTargets.isNotEmpty) {
          List<PositionModel> bombMoves = [];
          if (bomb == CharacterType.bomb) {
            bombMoves = bombMove(bombTargets.row, bombTargets.col, state, manual: true);
          }
          if (bomb == CharacterType.verticalBullet) {
            bombMoves = verticalMoves(bombTargets.row, bombTargets.col, state, manual: true);
          }
          if (bomb == CharacterType.horizontalBullet) {
            bombMoves = horizontalMoves(bombTargets.row, bombTargets.col, state, manual: true);
          }
          if (bomb == CharacterType.plane) {
            bombMoves = planeMoves(bombTargets.row, bombTargets.col, state, manual: true);
          }
          for (PositionModel bmb in bombMoves) {
            mvs.add(bmb);
          }
        }
      } else {
        mvs.add(findTargetOnBoards(state, mvs));
      }
    }
    return mvs;
  }

  static CharacterType getLastTarget(GameState state) {
    for (Map<CharacterType, int> target in state.targets) {
      if (target.entries.first.value > 0) {
        return target.entries.first.key;
      }
    }
    return CharacterType.hole;
  }

  static PositionModel findTargetOnBoards(
      GameState state, List<PositionModel> excepts) {
    List<PositionModel> targets = [];
    CharacterType lastTarget = getLastTarget(state);
    bool ex = false;
    for (int row = state.row; row >= 1; row--) {
      for (int col = state.col; col >= 1; col--) {
        CharacterType targetOnBard = getCharacter(state, row: row, col: col);
        //Except to finish latter
        for (PositionModel exp in excepts) {
          if ((exp == PositionModel(row: row, col: col))) {
            ex = true;
          }
        }
        //End except
        if (targetOnBard == lastTarget) {
          targets.add(PositionModel(row: row, col: col));
        }
      }
    }
    var rand = Random();
    if (targets.isEmpty) {
      return PositionModel.empty();
    }
    return targets[rand.nextInt(targets.length)];
  }

  static PositionModel findRandomCharacterOnBoards(
      GameState state, List<PositionModel> excepts) {
    List<PositionModel> targets = [];
    for (int row = state.row; row >= 1; row--) {
      for (int col = state.col; col >= 1; col--) {
        targets.add(PositionModel(row: row, col: col));
      }
    }
    var rand = Random();
    if (targets.isEmpty) {
      return PositionModel.empty();
    }
    return targets[rand.nextInt(targets.length)];
  }

  static List<PositionModel> findMatchedCharacter(
      GameState state, CharacterType matchCharacter) {
    List<PositionModel> targets = [];
    for (int row = state.row; row >= 1; row--) {
      for (int col = state.col; col >= 1; col--) {
        CharacterType targetOnBard = getCharacter(state, row: row, col: col);
        if (targetOnBard == matchCharacter) {
          targets.add(PositionModel(row: row, col: col));
        }
      }
    }
    return targets;
  }
}
