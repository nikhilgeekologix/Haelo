import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/editcounsel_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class EditCounselRepository {
  Future<Either<Failure, String>> fetchEditCounsel(Map<String, String> body);
}

class EditCounselRepositoryImpl implements EditCounselRepository {
  final NetworkInfo networkInfo;
  final EditCounselDataSource dataSource;

  const EditCounselRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchEditCounsel(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchEditCounsel(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
