import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import '../datasource/ticker_data_datasource.dart';

abstract class TickerDataRepository {
  Future<Either<Failure, String>> getTickerData(Map<String, String> body);
}

class TickerDataRepositoryImpl implements TickerDataRepository {
  final NetworkInfo networkInfo;
  final TickerDataDataSource dataSource;

  const TickerDataRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> getTickerData(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.TickerData(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
