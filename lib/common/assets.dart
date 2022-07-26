import 'dart:ui';

import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/ui/game/character.dart';

class Assets {
  static const String _characters = "assets/characters/";
  static const String _background = "assets/background/";
  static const String _materials = "assets/materials/";
  static const String _packages = "assets/packages/";
  static const String _gif = "assets/gif/";

  static const String apple = _characters + "red.png"; // "apple.png";
  static const String banana = _characters + "yellow.png"; // "banana.png";
  static const String blueBerry = _characters + "blue.png"; // "blue_berry.png";
  static const String orange = _characters + "orange.png"; // "orange.png";
  static const String pear = _characters + "green.png"; // "pear.png";
  static const String hole = _characters + "hole.png";
  static const String coin = _characters + "coin.png";
  static const String bomb = _characters + "bomb.png";
  static const String plane = _characters + "rocket.png"; // "plane.jpg";
  static const String hand = _characters + "hand.png";
  static const String carpet = _characters + "carpet.png";
  static const String hummer = _characters + "hummer.png";
  static const String heart = _characters + "heart.png";
  static const String heartBroken = _characters + "heart_broken.png";
  static const String bulletVertical = _characters + "vertical_bullet.png";
  static const String bulletHorizontal = _characters + "horizontal_bullet.png";
  static const String superBomb = _characters + "fireball.png"; // "super_bomb.png";

  static const String logo = _materials + "logo.png";
  static const String finalLogo = _materials + "final_logo.png";
  static const String shopWord = _materials + "shop.png";
  static const String shopWhiteWord = _materials + "shop_white.png";
  static const String restart = _materials + "restart.png";
  static const String superBombBlast = _materials + "super_bomb_blast.png";

  static const String chuiPackage = _packages + "chui_package.png";
  static const String simbaPackage = _packages + "simba_package.png";
  static const String swalaPackage = _packages + "swala_package.png";
  static const String temboPackage = _packages + "tembo_package.png";
  static const String twigaPackage = _packages + "twiga_package.png";

  static const String timeOnePackage = _packages + "time_one.png";
  static const String timeTwoPackage = _packages + "time_two.png";
  static const String timeThreePackage = _packages + "time_three.png";
  static const String timeFourPackage = _packages + "time_four.png";
  static const String timeFivePackage = _packages + "time_five.png";
  static const String timeTenPackage = _packages + "time_ten.png";
  static const String timeFifteenPackage = _packages + "time_kumi_tano.png";

  static const String coinBagPackage = _packages + "coin_bag.png";
  static const String coinFiftyThousandPackage = _packages + "coin_fifty_thousand.png";
  static const String coinFiveThousandPackage = _packages + "coin_five_thousand.png";
  static const String coinTenThousandPackage = _packages + "coin_ten_thousand.png";
  static const String coinTwentySevenThousandPackage = _packages + "coin_twenty_seven_thousand.png";
  static const String coinTwoThousandPackage = _packages + "coin_two_thousand.png";

  static const String logoGif = _gif + "logo.gif";

  static const String boxOne = _characters + "box_one.png";
  static const String boxTwo = _characters + "box_two.png";
  static const String boxThree = _characters + "box_three.png";

  static const String diamondOne = _characters + "diamond_one.png";
  static const String diamondTwo = _characters + "diamond_two.png";
  static const String diamondThree = _characters + "diamond_three.png";

  static const String background = _background + "background4.jpg";
  static const String gameOver = _background + "game_over.png";

  static const int characterColor = 0xFF94B8DB;
  static const int boardColor = 0xFFC2D6EB;

  static const int primaryColor = 0xFF94B8DB;
  static const int secondaryColor = 0xFF94B8DB;

  static const int blackColor = 0xFFF000000;
  static const int thirdColor = 0xFF767577;
  static const int redColors = 0xFFFF0000;

  static const int primaryGoldColor = 0xFFFFB828;
  static const int primaryRedColor = 0xFFF9203D;
  static const int primaryGreenColor = 0xFF3ED715;
  static const int primaryBlueColor = 0xFF134383;
  static const int primaryTargetBackgroundColor = 0xFFFBF1BC;
  static const int primaryPackageBackgroundColor = 0xFFB60531;

  static const Color circularProgressColor = Color.fromARGB(255, 232, 226, 238);

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
    if (characterType == CharacterType.space) {
      return Assets.hole;
    }
    if (characterType == CharacterType.carpet) {
      return Assets.carpet;
    }
    if (characterType == CharacterType.restart) {
      return Assets.restart;
    }
    if (characterType == CharacterType.coin) {
      return Assets.coin;
    }
    return Assets.hole;
  }

  static const Map<String,dynamic> level0 = {
    "row" : 9,
    "col" : 8,
    "targets": [],
    "rewards" : [RewardModel(character: CharacterType.hand, amount: 5),RewardModel(character: CharacterType.hummer, amount: 3), RewardModel(character: CharacterType.orange, amount: 4)],
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
    "rewards" : [RewardModel(character: CharacterType.superBomb, amount: 2), RewardModel(character: CharacterType.hand, amount: 100), RewardModel(character: CharacterType.verticalBullet, amount: 1),RewardModel(character: CharacterType.horizontalBullet, amount: 1), RewardModel(character: CharacterType.plane, amount: 2)],
    "targets": [{CharacterType.pear : 50},{CharacterType.banana : 50},{CharacterType.apple : 50}],
    "moves": 10,
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
    "targets": [{CharacterType.pear : 5},{CharacterType.banana : 5},{CharacterType.apple : 5}],
    "moves": 30,
    "rewards" : [RewardModel(character: CharacterType.hand, amount: 5),RewardModel(character: CharacterType.hummer, amount: 3), RewardModel(character: CharacterType.coin, amount: 5000)],
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
    "rewards" : [RewardModel(character: CharacterType.hand, amount: 5),RewardModel(character: CharacterType.hummer, amount: 3), RewardModel(character: CharacterType.orange, amount: 4)],
    "targets": [{CharacterType.boxOne : 5},{CharacterType.boxTwo: 5},{CharacterType.boxThree: 5}],
    "moves": 60,
    "board" : [
      [CharacterType.boxOne,CharacterType.boxTwo,CharacterType.boxThree,CharacterType.boxOne,CharacterType.boxOne,CharacterType.boxTwo,CharacterType.boxThree,CharacterType.boxOne,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.boxThree,CharacterType.boxTwo,CharacterType.boxOne,CharacterType.boxOne,],
      [CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,CharacterType.hole,],
      [CharacterType.space,CharacterType.space,CharacterType.space,CharacterType.space,CharacterType.space,CharacterType.space,CharacterType.space,CharacterType.space,],
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
    "targets": [{CharacterType.banana: 50, CharacterType.pear: 70}],
    "rewards" : [RewardModel(character: CharacterType.hand, amount: 5),RewardModel(character: CharacterType.hummer, amount: 3), RewardModel(character: CharacterType.orange, amount: 4)],
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
    "targets": [{CharacterType.carpet: 88}],
    "rewards" : [],
    "moves": 20,
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