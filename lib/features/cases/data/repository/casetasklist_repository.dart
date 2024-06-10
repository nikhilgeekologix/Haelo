import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/casetasklist_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CaseTaskListRepository {
  Future<Either<Failure, String>> fetchCaseTaskList(Map<String, String> body);
}

class CaseTaskListRepositoryImpl implements CaseTaskListRepository {
  final NetworkInfo networkInfo;
  final CaseTaskListDataSource dataSource;

  const CaseTaskListRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCaseTaskList(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCaseTaskList(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
