import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/displayboard_summary_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/office_stage_source.dart';

abstract class OfficeStageRepository {
  Future<Either<Failure, String>> fetchOfficeStage();
}

class OfficeStageRepositoryImpl implements OfficeStageRepository {
  final NetworkInfo networkInfo;
  final OfficeStageSource dataSource;

  const OfficeStageRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchOfficeStage() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchOfficeStage();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
