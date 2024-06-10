import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/home_tasklist_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class HomeTaskListRepository {
  Future<Either<Failure, String>> fetchHomeTaskList(Map<String, String>? body);
}

class HomeTaskListRepositoryImpl implements HomeTaskListRepository {
  final NetworkInfo networkInfo;
  final HomeTaskListDataSource dataSource;

  const HomeTaskListRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchHomeTaskList(Map<String, String>? body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchHomeTaskList(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
