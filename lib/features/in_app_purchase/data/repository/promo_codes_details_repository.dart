import 'package:dartz/dartz.dart';

import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/plan-details_data_source.dart';
import '../datasource/promo_code_details_data_source.dart';

abstract class PromoCodesRepository {
  Future<Either<Failure, String>> fetchPromoCodesDetails(
      Map<String, String> body);
}

class PromoCodesRepositoryImpl implements PromoCodesRepository {
  final NetworkInfo networkInfo;
  final PromoCodesDataSource dataSource;

  const PromoCodesRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchPromoCodesDetails(
      Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchPromoCodesDetails();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
