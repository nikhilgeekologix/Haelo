import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/addcase_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class AddCaseRepository {
  Future<Either<Failure, String>> fetchAddCase(Map<String, String> body, file);
}

class AddCaseRepositoryImpl implements AddCaseRepository {
  final NetworkInfo networkInfo;
  final AddCaseDataSource dataSource;

  const AddCaseRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchAddCase(Map<String, String> body, file) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchAddCase(body, file);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
