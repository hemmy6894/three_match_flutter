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
  static const String bulletVertical = _characters + "vertical_bullet.png";
  static const String bulletHorizontal = _characters + "horizontal_bullet.png";
  static const String superBomb = _characters + "super_bomb.png";

  static const String background = _background + "background.jpg";
  static const String gameOver = _background + "game_over.png";

  static const Map<String,dynamic> level1 = {
    "row" : 10,
    "col" : 10,
    "board" : [
      [1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,0,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1],
      [1,1,1,1,1,1,1,1,1,1],
    ]
  };
}