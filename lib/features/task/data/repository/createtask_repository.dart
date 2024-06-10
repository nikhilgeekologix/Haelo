import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/home_mytask_data_source.dart';
import 'package:haelo_flutter/features/task/data/datasource/cratetask_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CreateTaskRepository {
  Future<Either<Failure, String>> fetchCreateTask(Map<String, String> body, file);
}

class CreateTaskRepositoryImpl implements CreateTaskRepository {
  final NetworkInfo networkInfo;
  final CreateTaskDataSource dataSource;

  const CreateTaskRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCreateTask(Map<String, String> body, file) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCreateTask(body, file);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
