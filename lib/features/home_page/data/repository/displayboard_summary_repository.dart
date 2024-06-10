import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/displayboard_summary_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class DisplayBoardSummaryRepository {
  Future<Either<Failure, String>> fetchDisplayBoardSummary(Map<String, String> body);
}

class DisplayBoardSummaryRepositoryImpl implements DisplayBoardSummaryRepository {
  final NetworkInfo networkInfo;
  final DisplayBoardSummaryDataSource dataSource;

  const DisplayBoardSummaryRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchDisplayBoardSummary(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchDisplayBoardSummary(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
