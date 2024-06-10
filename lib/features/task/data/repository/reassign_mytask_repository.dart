import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/task/data/datasource/reassign_mytask_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class ReassignMyTaskRepository {
  Future<Either<Failure, String>> fetchReassignMyTask(Map<String, String> body);
}

class ReassignMyTaskRepositoryImpl implements ReassignMyTaskRepository {
  final NetworkInfo networkInfo;
  final ReassignMyTaskDataSource dataSource;

  const ReassignMyTaskRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchReassignMyTask(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchReassignMyTask(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
