import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/mycases_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class MyCasesRepository {
  Future<Either<Failure, String>> fetchMyCases(Map<String, String> body);
}

class MyCasesRepositoryImpl implements MyCasesRepository {
  final NetworkInfo networkInfo;
  final MyCasesDataSource dataSource;

  const MyCasesRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchMyCases(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchMyCases(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
