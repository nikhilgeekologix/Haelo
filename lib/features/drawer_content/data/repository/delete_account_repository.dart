import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/delete_account_datasource.dart';

abstract class DeleteAccountRepository {
  Future<Either<Failure, String>> deleteAccount();
}

class DeleteAccountRepositoryImpl implements DeleteAccountRepository {
  final NetworkInfo networkInfo;
  final DeleteAccountDataSource dataSource;

  const DeleteAccountRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.deleteAccount();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
