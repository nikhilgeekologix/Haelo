import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/task/data/datasource/taskdetailsbutton_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class TaskDetailsButtonRepository {
  Future<Either<Failure, String>> fetchTaskDetailsButton(Map<String, String> body, {file});
}

class TaskDetailsButtonRepositoryImpl implements TaskDetailsButtonRepository {
  final NetworkInfo networkInfo;
  final TaskDetailsButtonDataSource dataSource;

  const TaskDetailsButtonRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchTaskDetailsButton(Map<String, String> body, {file}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchTaskDetailsButton(body, file: file);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
