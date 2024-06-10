import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/court_date_report/data/datasource/court_date_report_datasource.dart';
import 'package:haelo_flutter/features/court_date_report/data/model/court_date_report_model.dart';
import '../../../../core/utils/exceptions.dart';

abstract class CourtDateReportRepository {
  // Future<Either<Failure, CourtDateReportModel>> fetchCourtDateReport(Map<String, String>? body);
  Future<Either<Failure, String>> fetchCourtDateReport(Map<String, String> body);
}
class CourtDateReportRepositoryImpl implements CourtDateReportRepository {
  final NetworkInfo networkInfo;
  final CourtDateReportDataSource dataSource;
  const CourtDateReportRepositoryImpl({required this.networkInfo, required this.dataSource});

  // @override
  // Future<Either<Failure, CourtDateReportModel>> fetchCourtDateReport(Map<String, String>? body) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //       final remoteCL = await dataSource.fetchCourtDateReport(body);
  //       return Right(remoteCL);
  //     } on ServerException catch (e) {
  //       return Left(ServerFailure(e.message));
  //     }
  //   } else {
  //     return Left(InternetFailure());
  //   }
  // }

  @override
  Future<Either<Failure, String>> fetchCourtDateReport(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCourtDateReport(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }



}