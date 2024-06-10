import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/addcase_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/unhide_causelist_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class UnHideCauseListRepository {
  Future<Either<Failure, String>> fetchUnHideCauseList(Map<String, String> body);
}

class UnHideCauseListRepositoryImpl implements UnHideCauseListRepository {
  final NetworkInfo networkInfo;
  final UnHideCauseListDataSource dataSource;

  const UnHideCauseListRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchUnHideCauseList(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchUnHideCauseList(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
