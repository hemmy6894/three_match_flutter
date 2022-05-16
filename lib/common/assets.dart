import 'package:test_game/game/ui/game/character.dart';

class Assets {
  static const String _characters = "assets/characters/";
  static const String _background = "assets/background/";
  static const String _materials = "assets/materials/";

  static const String restart = _materials + "restart.png";

  static const String apple = _characters + "apple.png";
  static const String banana = _characters + "banana.png";
  static const String blueBerry = _characters + "blue_berry.png";
  static const String orange = _characters + "orange.png";
  static const String pear = _characters + "pear.png";
  static const String hole = _characters + "hole.png";
  static const String bomb = _characters + "bomb.png";
  static const String plane = _characters + "plane.jpg";
  static const String hand = _characters + "hand.png";
  static const String carpet = _characters + "carpet.png";
  static const String hummer = _characters + "hummer.png";
  static const String bulletVertical = _characters + "vertical_bullet.png";
  static const String bulletHorizontal = _characters + "horizontal_bullet.png";
  static const String superBomb = _characters + "super_bomb.png";

  static const String boxOne = _characters + "box_one.png";
  static const String boxTwo = _characters + "box_two.png";
  static const String boxThree = _characters + "box_three.png";

  static const String diamondOne = _characters + "diamond_one.png";
  static const String diamondTwo = _characters + "diamond_two.png";
  static const String diamondThree = _characters + "diamond_three.png";

  static const String background = _background + "background.jpg";
  static const String gameOver = _background + "game_over.png";

  static const int characterColor = 0xFF94B8DB;
  static const int boardColor = 0xFFC2D6EB;

  static String getCharacter({required CharacterType characterType}) {
    if (characterType == CharacterType.banana) {
      return Assets.banana;
    }
    if (characterType == CharacterType.apple) {
      return Assets.apple;
    }
    if (characterType == CharacterType.pear) {
      return Assets.pear;
    }
    if (characterType == CharacterType.blueBerry) {
      return Assets.blueBerry;
    }
    if (characterType == CharacterType.orange) {
      return Assets.orange;
    }
    if (characterType == CharacterType.hole) {
      return Assets.hole;
    }
    if (characterType == CharacterType.bomb) {
      return Assets.bomb;
    }
    if (characterType == CharacterType.plane) {
      return Assets.plane;
    }
    if (characterType == CharacterType.verticalBullet) {
      return Assets.bulletVertical;
    }
    if (characterType == CharacterType.horizontalBullet) {
      return Assets.bulletHorizontal;
    }
    if (characterType == CharacterType.superBomb) {
      return Assets.superBomb;
    }
    if (characterType == CharacterType.hand) {
      return Assets.hand;
    }
    if (characterType == CharacterType.hummer) {
      return Assets.hummer;
    }
    if (characterType == CharacterType.boxOne) {
      return Assets.boxOne;
    }
    if (characterType == CharacterType.boxTwo) {
      return Assets.boxTwo;
    }
    if (characterType == CharacterType.boxThree) {
      return Assets.boxThree;
    }
    if (characterType == CharacterType.diamondOne) {
      return Assets.diamondOne;
    }
    if (characterType == CharacterType.diamondTwo) {
      return Assets.diamondTwo;
    }
    if (characterType == CharacterType.diamondThree) {
      return Assets.diamondThree;
    }
    return Assets.hole;
  }

  static const Map<String,dynamic> level0 = {
    "row" : 9,
    "col" : 8,
    "targets": [],
    "moves": 30,
    "board" : [
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.boxThree,CharacterType.boxThree,CharacterType.hole,CharacterType.hole,CharacterType.diamondThree,CharacterType.diamondThree,CharacterType.hole],
      [CharacterType.hole,CharacterType.boxTwo,CharacterType.boxTwo,CharacterType.hole,CharacterType.hole,CharacterType.diamondTwo,CharacterType.diamondTwo,CharacterType.hole],
      [CharacterType.hole,CharacterType.boxOne,CharacterType.boxOne,CharacterType.hole,CharacterType.hole,CharacterType.diamondOne,CharacterType.diamondOne,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
    ],
    "carpet" : {0: {0 : false}}
  };

  static const Map<String,dynamic> level1 = {
    "row" : 9,
    "col" : 8,
    "targets": [{CharacterType.pear : 1000},{CharacterType.banana : 1000},{CharacterType.apple : 1000}],
    "moves": 50,
    "board" : [
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole],
    ],
    "carpet" : {0: {0 : false}}
  };

  static const Map<String,dynamic> level2 = {
    "row" : 7,
    "col" : 5,
    "targets": [],
    "moves": 10,
    "board" : [
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.boxOne,CharacterType.boxOne,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.boxTwo,CharacterType.boxTwo,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.boxThree,CharacterType.boxThree,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
    ],
    "carpet" : {0: {0 : false}}
  };

  static const Map<String,dynamic> level3 = {
    "row" : 10,
    "col" : 8,
    "targets": [{CharacterType.boxOne : 12},{CharacterType.boxTwo: 6},{CharacterType.boxThree: 3}],
    "moves": 60,
    "board" : [
      [CharacterType.boxOne,CharacterType.boxTwo,CharacterType.boxThree,CharacterType.boxOne,CharacterType.boxOne,CharacterType.boxTwo,CharacterType.boxThree,CharacterType.boxOne,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.boxThree,CharacterType.boxTwo,CharacterType.boxOne,CharacterType.boxOne,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.diamondOne,CharacterType.diamondThree,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.diamondTwo,CharacterType.diamondTwo,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.diamondThree,CharacterType.diamondOne,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.diamondOne,CharacterType.diamondOne,CharacterType.diamondTwo,CharacterType.diamondTwo,CharacterType.diamondThree,CharacterType.diamondThree,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
    ],
    "carpet" : {0: {0 : false}}
  };

  static const Map<String,dynamic> level4 = {
    "row" : 7,
    "col" : 6,
    "targets": [],
    "moves": 10,
    "board" : [
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxOne,CharacterType.boxOne,CharacterType.boxTwo,CharacterType.boxTwo,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxThree,CharacterType.boxThree,CharacterType.boxOne,CharacterType.boxOne,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.diamondOne,CharacterType.diamondTwo,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.diamondOne,CharacterType.diamondTwo,CharacterType.diamondThree,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
    ],
    "carpet" : {0: {0 : false}}
  };

  static const Map<String,dynamic> level5 = {
    "row" : 11,
    "col" : 8,
    "targets": [],
    "moves": 10,
    "board" : [
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxOne,CharacterType.hole,CharacterType.hole,CharacterType.diamondOne,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxOne,CharacterType.hole,CharacterType.hole,CharacterType.diamondOne,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxTwo,CharacterType.hole,CharacterType.hole,CharacterType.diamondTwo,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxTwo,CharacterType.boxTwo,CharacterType.diamondTwo,CharacterType.diamondTwo,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxOne,CharacterType.hole,CharacterType.hole,CharacterType.diamondOne,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxOne,CharacterType.hole,CharacterType.hole,CharacterType.diamondOne,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxTwo,CharacterType.hole,CharacterType.hole,CharacterType.diamondTwo,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.boxThree,CharacterType.hole,CharacterType.hole,CharacterType.diamondTwo,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.boxThree,CharacterType.boxThree,],
    ],
    "carpet" : {
      11 : {7 : true, 8: true},
    }
  };

  static const List<Map<String,dynamic>> levels =
  [
    level0,
    level1,
    level2,
    level3,
    level4,
    level5
  ];
}