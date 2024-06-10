import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/orderhistory_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class OrderHistoryRepository {
  Future<Either<Failure, String>> fetchOrderHistory(Map<String, String> body);
}

class OrderHistoryRepositoryImpl implements OrderHistoryRepository {
  final NetworkInfo networkInfo;
  final OrderHistoryDataSource dataSource;

  const OrderHistoryRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchOrderHistory(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchOrderHistory(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
