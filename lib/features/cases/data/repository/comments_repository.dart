import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/comments_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CasesCommentRepository {
  Future<Either<Failure, String>> fetchCasesComment(Map<String, String> body);
}

class CasesCommentRepositoryImpl implements CasesCommentRepository {
  final NetworkInfo networkInfo;
  final CasesCommentDataSource dataSource;

  const CasesCommentRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCasesComment(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCasesComment(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
