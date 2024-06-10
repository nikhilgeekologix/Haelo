import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/pay_request_state.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/repository/plans_repository.dart';

import '../data/model/pay_request_model.dart';

class PayRequestCubit extends Cubit<PayRequestState> {
  final PlansRepository repo;

  PayRequestCubit(
    this.repo,
  ) : super(PayRequestInitial());

  Future<void> payRequest(Map<String, String> data) async {
    emit(PayRequestLoading());
    final Either<Failure, PayRequestModel> postsEither =
        await repo.payRequest(data);

    postsEither.fold(
      (failure) {
        print("in fail");
        print("in ${failure.toString()}");
        emit(PayRequestError(failure.toString()));
      },
      (postsList) {
        print("in success");
        emit(PayRequestLoaded(postsList));
      },
    );
  }
}
