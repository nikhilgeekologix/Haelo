import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/order_comment_history/data/datasource/order_comment_history_datasource.dart';
import 'package:haelo_flutter/features/order_comment_history/data/model/order_comment_history_model.dart';

import '../../../../core/utils/exceptions.dart';

abstract class OrderCommentHistoryRepository {
  // Future<Either<Failure, OrderCommentHistoryModel>> fetchOrderCmtHistory(Map<String, String>? body);
  Future<Either<Failure, String>> fetchOrderCmtHistory(
      Map<String, String> body);
}

class OrderCommentHistoryRepositoryImpl
    implements OrderCommentHistoryRepository {
  final NetworkInfo networkInfo;
  final OrderCommentHistoryDataSource dataSource;
  const OrderCommentHistoryRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  // @override
  // Future<Either<Failure, OrderCommentHistoryModel>> fetchOrderCmtHistory(Map<String, String>? body) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //       final remoteCL = await dataSource.fetchOrderCmtHistory(body);
  //       return Right(remoteCL);
  //     } on ServerException catch (e) {
  //       return Left(ServerFailure(e.message));
  //     }
  //   } else {
  //     return Left(InternetFailure());
  //   }
  // }

  @override
  Future<Either<Failure, String>> fetchOrderCmtHistory(
      Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchOrderCmtHistory(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
