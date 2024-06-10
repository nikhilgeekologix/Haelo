import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/aboutus_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CouponsRepository {
  Future<Either<Failure, String>> fetchCouponsList();
}

class CouponsRepositoryImpl implements CouponsRepository {
  final NetworkInfo networkInfo;
  final AboutUsDataSource dataSource;

  const CouponsRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCouponsList() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchAboutUs();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
