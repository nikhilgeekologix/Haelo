import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/createcase_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CauseListCreateCaseRepository {
  Future<Either<Failure, String>> fetchCauseListCreateCase(Map<String, String> body);
}

class CauseListCreateCaseRepositoryImpl implements CauseListCreateCaseRepository {
  final NetworkInfo networkInfo;
  final CauseListCreateCaseDataSource dataSource;

  const CauseListCreateCaseRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCauseListCreateCase(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCauseListCreateCase(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
