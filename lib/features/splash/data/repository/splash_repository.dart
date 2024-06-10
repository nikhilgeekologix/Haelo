import 'package:dartz/dartz.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/splash_data_source.dart';

abstract class SplashRepository {
  Future<Either<Failure, String>> getConfigData(Map<String, String> map);
}

class SplashRepositoryImpl implements SplashRepository {
  final NetworkInfo networkInfo;
  final SplashRemoteDataSource splashRemoteDataSource;

  const SplashRepositoryImpl(
      {required this.networkInfo, required this.splashRemoteDataSource});

  @override
  Future<Either<Failure, String>> getConfigData(Map<String, String> map) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await splashRemoteDataSource.fetchConfig(map);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
