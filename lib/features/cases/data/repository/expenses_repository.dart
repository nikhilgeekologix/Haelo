import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/expenses_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class ExpensesRepository {
  Future<Either<Failure, String>> fetchExpenses(Map<String, String> body);
}

class ExpensesRepositoryImpl implements ExpensesRepository {
  final NetworkInfo networkInfo;
  final ExpensesDataSource dataSource;

  const ExpensesRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchExpenses(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchExpenses(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
