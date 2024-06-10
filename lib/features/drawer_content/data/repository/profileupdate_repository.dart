import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/profileupdate_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class ProfileUpdateRepository {
  Future<Either<Failure, String>> fetchProfileUpdate(Map<String, String> body);
}

class ProfileUpdateRepositoryImpl implements ProfileUpdateRepository {
  final NetworkInfo networkInfo;
  final ProfileUpdateDataSource dataSource;

  const ProfileUpdateRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchProfileUpdate(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchProfileUpdate(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
