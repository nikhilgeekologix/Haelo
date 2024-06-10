import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/task/data/datasource/taskdetails_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class TaskDetailRepository {
  Future<Either<Failure, String>> fetchTaskDetail(Map<String, String> body);
}

class TaskDetailRepositoryImpl implements TaskDetailRepository {
  final NetworkInfo networkInfo;
  final TaskDetailDataSource dataSource;

  const TaskDetailRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchTaskDetail(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchTaskDetail(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
