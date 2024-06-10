import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/adddetails_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/update_manually_data_source.dart';

abstract class UpdateManuallyRepository {
  Future<Either<Failure, String>> fetchUpdateManually(Map<String, String> body);
}

class UpdateManuallyRepositoryImpl implements UpdateManuallyRepository {
  final NetworkInfo networkInfo;
  final UpdateManuallyDataSource dataSource;

  const UpdateManuallyRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchUpdateManually(
      Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchUpdateManually(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
