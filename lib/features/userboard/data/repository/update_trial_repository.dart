import 'package:dartz/dartz.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/login_data_source.dart';
import '../datasource/update_trial_data_source.dart';

abstract class UpdateTrialRepository {
  Future<Either<Failure, String>> fetchUpdateTrial();
}

class UpdateTrialRepositoryImpl implements UpdateTrialRepository {
  final NetworkInfo networkInfo;
  final UpdateTrialDataSource dataSource;

  const UpdateTrialRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchUpdateTrial() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchUpdateTrial();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
