part of 'game_bloc.dart';

class GameState extends Equatable {
  final Map<int, Map<int, CharacterType>> gameBoards;
  final Map<int, Map<int, bool>> carpets;
  final PositionModel firstClicked;
  final PositionModel secondClicked;
  final PositionModel tempClicked;
  final PositionModel tempSecClicked;
  final List<Map<CharacterType, int>> targets;
  final List<PositionModel> toBreak;
  final List<PositionModel> planes;
  final List<PositionModel> bombs;
  final List<PositionModel> bulletVerticals;
  final List<PositionModel> bulletHorizontals;
  final List<PositionModel> superBombs;
  final List<PositionModel> previousPosition;
  final List<PositionModel> currentPosition;
  final CharacterType? selectedHelper;
  final CharacterType? reduceHelperReward;
  final int col;
  final int moves;
  final int row;
  final int level;
  final List<RewardModel> rewards;
  final bool match;
  final bool reversed;
  final bool dropDown;
  final bool matchAll;
  final bool bombTouched;
  final bool clearSelectedBooster;
  final String? assignedId;
  final List<Map<CharacterType, int>> startWith;
  final bool checkHasNextMove;
  final PositionModel superBombBlast;

  const GameState(
      {required this.gameBoards,
      required this.carpets,
      required this.firstClicked,
      required this.tempClicked,
      required this.tempSecClicked,
      required this.targets,
      required this.rewards,
      required this.toBreak,
      required this.planes,
      required this.bombs,
      required this.bulletVerticals,
      required this.bulletHorizontals,
      required this.superBombs,
      required this.previousPosition,
      required this.currentPosition,
      required this.checkHasNextMove,
      required this.row,
      required this.col,
      required this.level,
      required this.moves,
      required this.match,
      required this.reversed,
      required this.dropDown,
      required this.matchAll,
      required this.selectedHelper,
      required this.reduceHelperReward,
      required this.bombTouched,
      required this.assignedId,
      required this.startWith,
      required this.clearSelectedBooster,
      required this.superBombBlast,
      required this.secondClicked});

  factory GameState.empty() => GameState(
      gameBoards: const {},
      carpets: const {},
      firstClicked: PositionModel.empty(),
      toBreak: const [],
      planes: const [],
      bulletVerticals: const [],
      bulletHorizontals: const [],
      bombs: const [],
      superBombs: const [],
      previousPosition: const [],
      currentPosition: const [],
      secondClicked: PositionModel.empty(),
      tempClicked: PositionModel.empty(),
      tempSecClicked: PositionModel.empty(),
      targets: const [],
      rewards: const [],
      moves: 10,
      col: 10,
      row: 11,
      level: 1,
      match: false,
      reversed: false,
      matchAll: false,
      checkHasNextMove: false,
      selectedHelper: null,
      reduceHelperReward: null,
      bombTouched: true,
      clearSelectedBooster: true,
      assignedId: null,
      superBombBlast: PositionModel.empty(),
      startWith: const [],
      dropDown: false);

  GameState copyWith({
    Map<int, Map<int, CharacterType>>? gameBoards,
    Map<int, Map<int, bool>>? carpets,
    PositionModel? firstClicked,
    PositionModel? secondClicked,
    PositionModel? tempClicked,
    PositionModel? tempSecClicked,
    List<Map<CharacterType, int>>? targets,
    List<Map<CharacterType, int>>? startWith,
    List<RewardModel>? rewards,
    List<PositionModel>? toBreak,
    List<PositionModel>? planes,
    List<PositionModel>? bulletHorizontals,
    List<PositionModel>? bulletVerticals,
    List<PositionModel>? bombs,
    List<PositionModel>? superBombs,
    List<PositionModel>? previousPosition,
    List<PositionModel>? currentPosition,
    int? moves,
    int? col,
    int? row,
    int? level,
    bool? match,
    bool? reversed,
    bool? clearSelectedBooster,
    bool? checkHasNextMove,
    bool? dropDown,
    bool? matchAll,
    bool? bombTouched,
    String? assignedId,
    CharacterType? selectedHelper,
    CharacterType? reduceHelperReward,
    PositionModel? superBombBlast,
  }) {
    return GameState(
      gameBoards: gameBoards ?? this.gameBoards,
      carpets: carpets ?? this.carpets,
      firstClicked: firstClicked ?? this.firstClicked,
      secondClicked: secondClicked ?? this.secondClicked,
      tempClicked: tempClicked ?? this.tempClicked,
      tempSecClicked: tempSecClicked ?? this.tempSecClicked,
      targets: targets ?? this.targets,
      startWith: startWith ?? this.startWith,
      rewards: rewards ?? this.rewards,
      toBreak: toBreak ?? this.toBreak,
      planes: planes ?? this.planes,
      bulletVerticals: bulletVerticals ?? this.bulletVerticals,
      bulletHorizontals: bulletHorizontals ?? this.bulletHorizontals,
      bombs: bombs ?? this.bombs,
      superBombs: superBombs ?? this.superBombs,
      previousPosition: previousPosition ?? this.previousPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      moves: moves ?? this.moves,
      row: row ?? this.row,
      col: col ?? this.col,
      level: level ?? this.level,
      clearSelectedBooster: clearSelectedBooster ?? this.clearSelectedBooster,
      checkHasNextMove: checkHasNextMove ?? this.checkHasNextMove,
      match: match ?? this.match,
      reversed: reversed ?? this.reversed,
      matchAll: matchAll ?? this.matchAll,
      dropDown: dropDown ?? this.dropDown,
      bombTouched: bombTouched ?? this.bombTouched,
      assignedId: assignedId ?? this.assignedId,
      selectedHelper: selectedHelper ?? this.selectedHelper,
      reduceHelperReward: reduceHelperReward ?? this.reduceHelperReward,
      superBombBlast: superBombBlast ?? this.superBombBlast,
    );
  }

  bool checkClicked({required int row, required int col}) {
    bool clicked = false;
    if (firstClicked != PositionModel.empty()) {
      int firstRow = firstClicked.row;
      int firstCol = firstClicked.col;
      if ((row == firstRow && col == firstCol)) {
        clicked = true;
      }
    }
    return clicked;
  }

  bool hasCarpet({required int row, required int col}) {
    bool clicked = false;
    clicked = (carpets[row] ?? {})[col] ?? false;
    return clicked;
  }

  bool targetIsOver() {
    bool target = false;
    int totalTarget = 0;
    for (Map<CharacterType, int> trg in targets) {
      totalTarget += trg.entries.first.value;
    }
    if (totalTarget < 1) {
      target = true;
    }
    return target;
  }

  @override
  List<Object?> get props => [
        gameBoards.entries,
        carpets.entries,
        firstClicked.toMap(),
        secondClicked.toMap(),
        col,
        row,
        level,
        moves,
        match,
        tempClicked.toMap(),
        tempSecClicked.toMap(),
        previousPosition,
        currentPosition,
        reversed,
        toBreak,
        planes,
        bulletVerticals,
        bulletHorizontals,
        clearSelectedBooster,
        checkHasNextMove,
        bombs,
        superBombs,
        dropDown,
        matchAll,
        bombTouched,
        selectedHelper,
        reduceHelperReward,
        targets,
        startWith,
        assignedId,
        rewards,
        superBombBlast,
      ];

  int? selectedBooster({required CharacterType booster}) {
    for (Map<CharacterType, int> start in startWith) {
      if (start.entries.first.key == booster) {
        return start.entries.first.value;
      }
    }
    return null;
  }
}
