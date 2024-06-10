import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/features/order_comment_history/cubit/order_comment_history_state.dart';
import 'package:haelo_flutter/features/order_comment_history/data/model/order_comment_history_model.dart';
import 'package:haelo_flutter/features/order_comment_history/data/repository/order_comment_history_repository.dart';

import '../data/datasource/order_comment_history_datasource.dart';

// class OrderCommentHistoryCubit extends Cubit<OrderCommentHistoryState> {
//   final OrderCommentHistoryRepository repo;
//   OrderCommentHistoryCubit(
//       this.repo,
//       ) : super(OrderCommentHistoryInitial());
//
//   Future<void> fetchOrderCmtHistory(Map<String, String>? body) async {
//     emit(OrderCommentHistoryLoading());
//     final Either<Failure, OrderCommentHistoryModel> postsEither =
//     await repo.fetchOrderCmtHistory(body);
//     postsEither.fold(
//           (failure) {
//         print("in fail");
//         print("in ${failure.toString()}");
//         emit(OrderCommentHistoryError(failure.toString()));
//       },
//           (postsList) {
//         print("in success");
//         emit(OrderCommentHistoryLoaded(postsList));
//       },
//     );
//   }
// }

class OrderCommentHistoryCubit extends Cubit<OrderCommentHistoryState> {
  final OrderCommentHistoryDataSource dataSource;
  OrderCommentHistoryCubit(this.dataSource)
      : super(OrderCommentHistoryInitial());

  void fetchOrderCmtHistory(Map<String, String> body) {
    emit(OrderCommentHistoryLoading());
    dataSource
        .fetchOrderCmtHistory(body)
        .then((value) => {emit(OrderCommentHistoryLoaded(value))});
  }
}
