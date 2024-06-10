import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/task/data/datasource/delete_mytask_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class DeleteMyTaskRepository {
  Future<Either<Failure, String>> fetchDeleteMyTask(Map<String, String> body);
}

class DeleteMyTaskRepositoryImpl implements DeleteMyTaskRepository {
  final NetworkInfo networkInfo;
  final DeleteMyTaskDataSource dataSource;

  const DeleteMyTaskRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchDeleteMyTask(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchDeleteMyTask(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
