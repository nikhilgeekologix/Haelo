import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/docdelete_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class DocDeleteRepository {
  Future<Either<Failure, String>> fetchDocDelete(Map<String, String> body);
}

class DocDeleteRepositoryImpl implements DocDeleteRepository {
  final NetworkInfo networkInfo;
  final DocDeleteDataSource dataSource;

  const DocDeleteRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchDocDelete(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchDocDelete(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
