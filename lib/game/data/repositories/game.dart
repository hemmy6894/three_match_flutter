import 'package:either_dart/either.dart';
import 'package:test_game/common/requests/response.dart';
import 'package:test_game/game/data/models/error.dart';
import 'package:test_game/game/data/models/user_data.dart';
import 'package:test_game/game/data/models/user_list.dart';
import 'package:test_game/game/data/providers/game.dart';
import 'package:test_game/game/data/responses/assign_list_response.dart';
import 'package:test_game/game/data/responses/country_list_response.dart';
import 'package:test_game/game/data/responses/friend_list_response.dart';
import 'package:test_game/game/data/responses/gender_list_response.dart';
import 'package:test_game/game/data/responses/simple_response.dart';
import 'package:test_game/game/data/responses/task_list_response.dart';
import 'package:test_game/game/data/responses/user_list_response.dart';
import 'package:test_game/game/data/responses/user_response.dart';

class GameRepository {
  static Future<Either<UserResponse, ErrorMap>> getUserToken(
      {payload, token = ""}) async {
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
      {payload, token = ""}) async {
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

  static Future<Either<UserResponse, ErrorMap>> updateUser(
      {payload, token = ""}) async {
    Response response =
        await GameProvider.updateUser(payload: payload, token: token);
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

  static Future<Either<dynamic, ErrorMap>> friendRequest(
      {payload, token = ""}) async {
    Response response =
        await GameProvider.friendRequest(payload: payload, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(response.body);
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

  static Future<Either<FriendListResponse, ErrorMap>> friends(
      {payload, token = ""}) async {
    Response response =
        await GameProvider.friends(payload: payload, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(FriendListResponse.fromMap(response.data));
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

  static Future<Either<TaskListResponse, ErrorMap>> tasks(
      {payload, token = ""}) async {
    Response response =
        await GameProvider.tasks(payload: payload, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(TaskListResponse.fromMap(response.data));
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

  static Future<Either<SimpleResponse, ErrorMap>> assignTask(
      {payload, token = ""}) async {
    Response response = await GameProvider.assignTasks(payload: payload, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(SimpleResponse.fromMap(response.data));
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

  static Future<Either<SimpleResponse, ErrorMap>> wonTask(String task,
      {payload, token = ""}) async {
    Response response = await GameProvider.taskWon(task,payload: {"_method": "PUT","won":"won"}, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(SimpleResponse.fromMap(response.data));
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

  static Future<Either<AssignListResponse, ErrorMap>> pullAssigns(
      {payload, token = ""}) async {
    Response response =
        await GameProvider.pullAssigns(payload: payload, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(AssignListResponse.fromMap(response.data));
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

  static Future<Either<GenderListResponse, ErrorMap>> getGenders(
      {payload, token = ""}) async {
    Response response =
        await GameProvider.getGenders(payload: payload, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(GenderListResponse.fromMap(response.data));
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

  static Future<Either<CountryListResponse, ErrorMap>> getCountries(
      {payload, token = ""}) async {
    Response response =
        await GameProvider.getCountries(payload: payload, token: token);
    if (response.status ~/ 100 == 2) {
      return Left(CountryListResponse.fromMap(response.data));
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
