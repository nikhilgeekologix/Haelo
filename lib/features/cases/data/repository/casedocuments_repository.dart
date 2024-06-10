import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casedocuments_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CaseDocumentsRepository {
  Future<Either<Failure, String>> fetchCaseDocuments(Map<String, String> body);
}

class CaseDocumentsRepositoryImpl implements CaseDocumentsRepository {
  final NetworkInfo networkInfo;
  final CaseDocumentsDataSource dataSource;

  const CaseDocumentsRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCaseDocuments(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCaseDocuments(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
