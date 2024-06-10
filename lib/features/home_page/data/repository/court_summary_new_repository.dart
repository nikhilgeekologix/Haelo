import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/court_summary_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/court_summary_new_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CourtSummaryNewRepository {
  Future<Either<Failure, String>> fetchCourtNewSummary();
}

class CourtSummaryNewRepositoryImpl implements CourtSummaryNewRepository {
  final NetworkInfo networkInfo;
  final CourtSummaryNewDataSource dataSource;

  const CourtSummaryNewRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCourtNewSummary() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCourtSummaryNew();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
