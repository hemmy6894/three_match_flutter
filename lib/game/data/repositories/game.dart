import 'package:either_dart/either.dart';
import 'package:test_game/common/requests/response.dart';
import 'package:test_game/game/data/models/error.dart';
import 'package:test_game/game/data/providers/game.dart';
import 'package:test_game/game/data/responses/user_response.dart';

class GameRepository {
  static Future<Either<UserResponse, ErrorMap>> getUserToken(
      {payload,
      token = ""}) async {
    Response response =
        await GameProvider.getUserToken(payload: payload, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(UserResponse.fromMap(response.data));
    } else {
      return Right(
        ErrorMap(
          body: response.body,
          message: response.message,
          errorMap: response.data,
          status: response.status,
        ),
      );
    }
  }

  static Future<Either<UserResponse, ErrorMap>> registerUser(
      {payload,
        token = ""}) async {
    Response response =
    await GameProvider.registerUser(payload: payload, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(UserResponse.fromMap(response.data));
    } else {
      return Right(
        ErrorMap(
          body: response.body,
          message: response.message,
          errorMap: response.data,
          status: response.status,
        ),
      );
    }
  }
}
