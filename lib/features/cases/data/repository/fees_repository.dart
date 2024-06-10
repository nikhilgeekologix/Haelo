import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/fees_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class FeesRepository {
  Future<Either<Failure, String>> fetchFees(Map<String, String> body);
}

class FeesRepositoryImpl implements FeesRepository {
  final NetworkInfo networkInfo;
  final FeesDataSource dataSource;

  const FeesRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchFees(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchFees(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
