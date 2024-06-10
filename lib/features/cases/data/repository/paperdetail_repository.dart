import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/paperdetail_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class PaperDetailRepository {
  Future<Either<Failure, String>> fetchPaperDetail(Map<String, String> body);
}

class PaperDetailRepositoryImpl implements PaperDetailRepository {
  final NetworkInfo networkInfo;
  final PaperDetailDataSource dataSource;

  const PaperDetailRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchPaperDetail(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchPaperDetail(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
