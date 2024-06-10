import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/deletecomment_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class DeleteCommentRepository {
  Future<Either<Failure, String>> fetchDeleteComment(Map<String, String> body);
}

class DeleteCommentRepositoryImpl implements DeleteCommentRepository {
  final NetworkInfo networkInfo;
  final DeleteCommentDataSource dataSource;

  const DeleteCommentRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchDeleteComment(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchDeleteComment(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
