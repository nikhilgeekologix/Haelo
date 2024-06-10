import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casedetails_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CaseDetailRepository {
  Future<Either<Failure, String>> fetchCaseDetail(Map<String, String> body);
}

class CaseDetailRepositoryImpl implements CaseDetailRepository {
  final NetworkInfo networkInfo;
  final CaseDetailDataSource dataSource;

  const CaseDetailRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCaseDetail(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCaseDetail(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
