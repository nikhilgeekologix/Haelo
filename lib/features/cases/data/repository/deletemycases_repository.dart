import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/deletemycases_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class DeleteMyCaseRepository {
  Future<Either<Failure, String>> fetchDeleteMyCase(Map<String, String> body);
}

class DeleteMyCaseRepositoryImpl implements DeleteMyCaseRepository {
  final NetworkInfo networkInfo;
  final DeleteMyCaseDataSource dataSource;

  const DeleteMyCaseRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchDeleteMyCase(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchDeleteMyCase(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
