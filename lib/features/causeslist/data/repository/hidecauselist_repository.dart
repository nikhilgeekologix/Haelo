import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/hidecauselist_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class HideCauseListRepository {
  Future<Either<Failure, String>> fetchHideCauseList(Map<String, String> body);
}

class HideCauseListRepositoryImpl implements HideCauseListRepository {
  final NetworkInfo networkInfo;
  final HideCauseListDataSource dataSource;

  const HideCauseListRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchHideCauseList(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchHideCauseList(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
