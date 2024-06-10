import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/commentshistory_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CommentsHistoryRepository {
  Future<Either<Failure, String>> fetchCommentsHistory(Map<String, String> body);
}

class CommentsHistoryRepositoryImpl implements CommentsHistoryRepository {
  final NetworkInfo networkInfo;
  final CommentsHistoryDataSource dataSource;

  const CommentsHistoryRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCommentsHistory(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCommentsHistory(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
