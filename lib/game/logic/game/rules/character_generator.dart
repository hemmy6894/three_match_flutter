part of '../game_bloc.dart';

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
  CharacterType.boxOne,
  CharacterType.boxTwo,
  CharacterType.boxThree,
];

List<CharacterType> boxes = [
  CharacterType.boxOne,
  CharacterType.boxTwo,
  CharacterType.boxThree,
];

class CharacterGenerator {
  static getUniqueRandomCharacter(gameBoards, row, col) {
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
}