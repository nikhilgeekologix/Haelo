import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/mobileemailupdate_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class MobileEmailUpdateRepository {
  Future<Either<Failure, String>> fetchMobileEmailUpdate(Map<String, String> body);
}

class MobileEmailUpdateRepositoryImpl implements MobileEmailUpdateRepository {
  final NetworkInfo networkInfo;
  final MobileEmailUpdateDataSource dataSource;

  const MobileEmailUpdateRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchMobileEmailUpdate(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchMobileEmailUpdate(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
