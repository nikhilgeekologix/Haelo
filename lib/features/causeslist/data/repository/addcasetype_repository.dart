import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/addcase_data_source.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/addcasetype_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class AddCaseTypeRepository {
  Future<Either<Failure, String>> fetchAddCaseType();
}

class AddCaseTypeRepositoryImpl implements AddCaseTypeRepository {
  final NetworkInfo networkInfo;
  final AddCaseTypeDataSource dataSource;

  const AddCaseTypeRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchAddCaseType() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchAddCaseType();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
