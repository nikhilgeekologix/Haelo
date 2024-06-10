import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/updatecomment_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class UpdateCommentRepository {
  Future<Either<Failure, String>> fetchUpdateComment(Map<String, String> body);
}

class UpdateCommentRepositoryImpl implements UpdateCommentRepository {
  final NetworkInfo networkInfo;
  final UpdateCommentDataSource dataSource;

  const UpdateCommentRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchUpdateComment(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchUpdateComment(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
