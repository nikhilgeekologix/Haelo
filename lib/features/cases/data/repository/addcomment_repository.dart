import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/addcomment_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class AddCommentRepository {
  Future<Either<Failure, String>> fetchAddComment(Map<String, String> body);
  Future<Either<Failure, String>> fetchCmtSuggestion(Map<String, String> body);
}

class AddCommentRepositoryImpl implements AddCommentRepository {
  final NetworkInfo networkInfo;
  final AddCommentDataSource dataSource;

  const AddCommentRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchAddComment(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchAddComment(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> fetchCmtSuggestion(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCmtSuggestion(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
