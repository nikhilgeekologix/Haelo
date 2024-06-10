import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/addexpensesfees_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class AddExpensesFeesRepository {
  Future<Either<Failure, String>> fetchAddExpensesFees(Map<String, String> body);
}

class AddExpensesFeesRepositoryImpl implements AddExpensesFeesRepository {
  final NetworkInfo networkInfo;
  final AddExpensesFeesDataSource dataSource;

  const AddExpensesFeesRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchAddExpensesFees(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchAddExpensesFees(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
