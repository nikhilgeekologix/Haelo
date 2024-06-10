import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/userboard/data/datasource/login_verify_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/login_data_source.dart';

abstract class LoginVerifyRepository {
  Future<Either<Failure, String>> fetchLoginVerify(Map<String, String> body);
}

class LoginVerifyRepositoryImpl implements LoginVerifyRepository {
  final NetworkInfo networkInfo;
  final LoginVerifyDataSource dataSource;

  const LoginVerifyRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchLoginVerify(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchLoginVerify(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
