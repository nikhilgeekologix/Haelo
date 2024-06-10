import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/my_subscription_state.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/repository/plans_repository.dart';
import '../data/model/my_subscription_model.dart';


class MySubscriptionCubit extends Cubit<MySubscriptionState> {
  final PlansRepository repo;

  MySubscriptionCubit(
      this.repo,
      ) : super(MySubscriptionInitial());

  Future<void> fetchAllMySubscription() async {
    emit(MySubscriptionLoading());
    final Either<Failure, MySubscriptionModel> postsEither =
    await repo.fetchMySubscription();

    postsEither.fold(
          (failure) {
        print("in fail");
        print("in ${failure.toString()}");
        emit(MySubscriptionError(failure.toString()));
      },
          (postsList) {
        print("in success");
        emit(MySubscriptionLoaded(postsList));
      },
    );
  }
}
