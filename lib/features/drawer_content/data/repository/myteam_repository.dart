import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/myteam_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class MyTeamRepository {
  Future<Either<Failure, String>> fetchMyTeam(Map<String, String> body);
}

class MyTeamRepositoryImpl implements MyTeamRepository {
  final NetworkInfo networkInfo;
  final MyTeamDataSource dataSource;

  const MyTeamRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchMyTeam(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchMyTeam(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
