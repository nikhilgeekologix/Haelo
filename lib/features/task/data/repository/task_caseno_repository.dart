import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/task/data/datasource/task_caseno_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class TaskCaseNoRepository {
  Future<Either<Failure, String>> fetchTaskCaseNo();
}

class TaskCaseNoRepositoryImpl implements TaskCaseNoRepository {
  final NetworkInfo networkInfo;
  final TaskCaseNoDataSource dataSource;

  const TaskCaseNoRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchTaskCaseNo() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchTaskCaseNo();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
