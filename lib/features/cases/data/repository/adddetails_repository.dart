import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/cases/data/datasource/adddetails_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class AddDetailsRepository {
  Future<Either<Failure, String>> fetchAddDetails(Map<String, String> body);
}

class AddDetailsRepositoryImpl implements AddDetailsRepository {
  final NetworkInfo networkInfo;
  final AddDetailsDataSource dataSource;

  const AddDetailsRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchAddDetails(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchAddDetails(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
