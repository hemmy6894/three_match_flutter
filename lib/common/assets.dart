import 'package:test_game/game/ui/game/character.dart';

class Assets {
  static const String _characters = "assets/characters/";
  static const String _background = "assets/background/";

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

  static const Map<String,dynamic> level1 = {
    "row" : 9,
    "col" : 8,
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
    ]
  };
}