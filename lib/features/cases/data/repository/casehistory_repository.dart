import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casehistory_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CaseHistoryRepository {
  Future<Either<Failure, String>> fetchCaseHistory(Map<String, String> body);
}

class CaseHistoryRepositoryImpl implements CaseHistoryRepository {
  final NetworkInfo networkInfo;
  final CaseHistoryDataSource dataSource;

  const CaseHistoryRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCaseHistory(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCaseHistory(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
