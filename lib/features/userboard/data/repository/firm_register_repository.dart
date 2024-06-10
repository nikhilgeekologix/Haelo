import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/userboard/data/datasource/firm_register_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class FirmRegisterRepository {
  Future<Either<Failure, String>> fetchFirmRegister(Map<String, String> body);
}

class FirmRegisterRepositoryImpl implements FirmRegisterRepository {
  final NetworkInfo networkInfo;
  final FirmRegisterDataSource dataSource;

  const FirmRegisterRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchFirmRegister(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchFirmRegister(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
