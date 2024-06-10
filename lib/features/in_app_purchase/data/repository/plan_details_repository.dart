import 'package:dartz/dartz.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/plan-details_data_source.dart';

abstract class PlanDetailsRepository {
  Future<Either<Failure, String>> fetchPlanDetails(Map<String, String> body);
}

class PlanDetailsRepositoryImpl implements PlanDetailsRepository {
  final NetworkInfo networkInfo;
  final PlanDetailsDataSource dataSource;

  const PlanDetailsRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchPlanDetails(
      Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchPlanDetails();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
