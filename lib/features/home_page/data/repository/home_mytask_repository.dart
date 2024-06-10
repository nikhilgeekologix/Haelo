import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/home_mytask_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class HomeMyTaskRepository {
  Future<Either<Failure, String>> fetchHomeMyTask(Map<String, String> body);
}

class HomeMyTaskRepositoryImpl implements HomeMyTaskRepository {
  final NetworkInfo networkInfo;
  final HomeMyTaskDataSource dataSource;

  const HomeMyTaskRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchHomeMyTask(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchHomeMyTask(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
