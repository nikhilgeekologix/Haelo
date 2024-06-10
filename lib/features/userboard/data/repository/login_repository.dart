import 'package:dartz/dartz.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/login_data_source.dart';

abstract class LoginRepository {
  Future<Either<Failure, String>> fetchAdminUser();
}

class LoginRepositoryImpl implements LoginRepository {
  final NetworkInfo networkInfo;
  final LoginDataSource dataSource;

  const LoginRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchAdminUser() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchAdminUser();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
