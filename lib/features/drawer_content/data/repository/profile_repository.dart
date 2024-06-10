import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/profile_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class ProfileRepository {
  Future<Either<Failure, String>> fetchProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final NetworkInfo networkInfo;
  final ProfileDataSource dataSource;

  const ProfileRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchProfile();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
