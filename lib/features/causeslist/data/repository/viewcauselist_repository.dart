import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/viewcauselist_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class ViewCauseListRepository {
  Future<Either<Failure, String>> fetchViewCauseList(Map<String, String> body);
  Future<Either<Failure, String>> fetchQuickSearchData(
      Map<String, String> body);
}

class ViewCauseListRepositoryImpl implements ViewCauseListRepository {
  final NetworkInfo networkInfo;
  final ViewCauseListDataSource dataSource;

  const ViewCauseListRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchViewCauseList(
      Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchViewCauseList(body, "3.0");
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> fetchQuickSearchData(
      Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchQuickSearchData(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
