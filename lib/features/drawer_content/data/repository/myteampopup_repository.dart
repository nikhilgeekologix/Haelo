import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/myteampopup_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class MyTeamPopupRepository {
  Future<Either<Failure, String>> fetchMyTeamPopup(Map<String, String> body);
}

class MyTeamPopupRepositoryImpl implements MyTeamPopupRepository {
  final NetworkInfo networkInfo;
  final MyTeamPopupDataSource dataSource;

  const MyTeamPopupRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchMyTeamPopup(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchMyTeamPopup(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
