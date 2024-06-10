import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/task/data/datasource/task_caseno_data_source.dart';
import 'package:haelo_flutter/features/task/data/datasource/task_selectteam_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class TaskSelectTeamRepository {
  Future<Either<Failure, String>> fetchTaskSelectTeam();
}

class TaskSelectTeamRepositoryImpl implements TaskSelectTeamRepository {
  final NetworkInfo networkInfo;
  final TaskSelectTeamDataSource dataSource;

  const TaskSelectTeamRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchTaskSelectTeam() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchTaskSelectTeam();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
