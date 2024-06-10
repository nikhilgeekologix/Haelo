import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/main_causelistdata_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class MainCauseListDataRepository {
  Future<Either<Failure, String>> fetchMainCauseListData(Map<String, String> body);
}

class MainCauseListDataRepositoryImpl implements MainCauseListDataRepository {
  final NetworkInfo networkInfo;
  final MainCauseListDataDataSource dataSource;

  const MainCauseListDataRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchMainCauseListData(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchMainCauseListData(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
