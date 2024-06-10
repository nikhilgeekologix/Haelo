import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/displayboard_summary_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/order_cmt_history_data_sourse.dart';

abstract class OrderCmtHistoryRepository {
  Future<Either<Failure, String>> fetchDisplayBoardStageItem(
      Map<String, String> body);
}

class OrderCmtHistoryRepositoryImpl implements OrderCmtHistoryRepository {
  final NetworkInfo networkInfo;
  final OrderCmtHistoryDataSource dataSource;

  const OrderCmtHistoryRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchDisplayBoardStageItem(
      Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchOrderCmtHistoryData(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
