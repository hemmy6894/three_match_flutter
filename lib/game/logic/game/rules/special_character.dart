part of '../game_bloc.dart';
class SpecialCharacter {
  static List<PositionModel> checkPlane(GameState state, List<PositionModel> horizontal,
      List<PositionModel> vertical, PositionModel current) {
    if (horizontal.isNotEmpty && vertical.isNotEmpty) {
      if (current.isNotEmpty) {
        int horizontalRow = horizontal[0].row;
        int horizontalCol = horizontal[0].col;

        int verticalRow = vertical[0].row;
        int verticalCol = vertical[0].col;

        int currentRow = current.row;
        int currentCol = current.col;

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
              PositionModel(row: newRow, col: newCol)
            ];
          }
        }
      }
    }
    return [];
  }

  static checkBulletHorizontal(List<PositionModel> horizontal, List<PositionModel> vertical,
      Map<int, int> current) {
    if (vertical.length == 3) {
      return [current];
    }
    return [];
  }

  static checkBulletVertical(List<PositionModel> horizontal, List<PositionModel> vertical,
      Map<int, int> current) {
    if (horizontal.length == 3) {
      return [current];
    }
    return [];
  }

  static checkBombs(List<PositionModel> horizontal, List<PositionModel> vertical,
      Map<int, int> current) {
    if (horizontal.length == 2 && vertical.length == 2) {
      return [current];
    }
    return [];
  }

  static checkSuperBombs(List<PositionModel> horizontal, List<PositionModel> vertical,
      Map<int, int> current) {
    if (horizontal.length >= 4 || vertical.length >= 4) {
      return [current];
    }
    return [];
  }

  static CharacterType getBullet() {
    var rand = Random();
    return rand.nextInt(1000) % 2 == 0
        ? CharacterType.verticalBullet
        : CharacterType.horizontalBullet;
  }
}