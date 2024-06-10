import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/faq_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class FAQRepository {
  Future<Either<Failure, String>> fetchFAQ();
}

class FAQRepositoryImpl implements FAQRepository {
  final NetworkInfo networkInfo;
  final FAQDataSource dataSource;

  const FAQRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchFAQ() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchFAQ();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
