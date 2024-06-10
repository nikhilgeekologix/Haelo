import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/court_summary_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CourtSummaryRepository {
  Future<Either<Failure, String>> fetchCourtSummary(Map<String, String> body);
}

class CourtSummaryRepositoryImpl implements CourtSummaryRepository {
  final NetworkInfo networkInfo;
  final CourtSummaryDataSource dataSource;

  const CourtSummaryRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCourtSummary(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCourtSummary(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
