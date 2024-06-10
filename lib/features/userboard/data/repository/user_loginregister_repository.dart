import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/userboard/data/datasource/user_loginregister_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class UserLoginRegisterRepository {
  Future<Either<Failure, String>> fetchUserLoginRegister(Map<String, String> body);
}

class UserLoginRegisterRepositoryImpl implements UserLoginRegisterRepository {
  final NetworkInfo networkInfo;
  final UserLoginRegisterDataSource dataSource;

  const UserLoginRegisterRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchUserLoginRegister(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchUserLoginRegister(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
