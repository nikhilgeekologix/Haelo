import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/alert/data/datasource/my_alert_datasource.dart';

abstract class MyAlertRepository {
  Future<Either<Failure, String>> fetchMyAlert();
  Future<Either<Failure, String>> deleteAlert(Map<String, String> body);
  Future<Either<Failure, String>> addEventToCalendar(Map<String, String> body);
  Future<Either<Failure, String>> autoDownload(Map<String, String> body);
  Future<Either<Failure, String>> deleteWatchlist(Map<String, String> body);
  Future<Either<Failure, String>> editWatchlist(Map<String, String> body);
}

class MyAlertRepositoryImpl implements MyAlertRepository {
  final NetworkInfo networkInfo;
  final MyAlertDataSource dataSource;

  const MyAlertRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchMyAlert() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchMyAlert();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteAlert(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.deleteAlert(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteWatchlist(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.deleteWatchlist(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editWatchlist(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.editWatchlist(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addEventToCalendar(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.addEventToCalendar(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> autoDownload(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.autoDownload(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
