import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/hidden%20_causelist_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class HiddenCauseListRepository {
  Future<Either<Failure, String>> fetchHiddenCauseList();
}

class HiddenCauseListRepositoryImpl implements HiddenCauseListRepository {
  final NetworkInfo networkInfo;
  final HiddenCauseListDataSource dataSource;

  const HiddenCauseListRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchHiddenCauseList() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchHiddenCauseList();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
