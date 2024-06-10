import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/features/in_app_purchase/cubit/plans_state.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/plans_model.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/repository/plans_repository.dart';


class PlansCubit extends Cubit<PlansState> {
  final PlansRepository repo;

  PlansCubit(
      this.repo,
      ) : super(PlansInitial());

  Future<void> fetchAllPlans() async {
    emit(PlansLoading());
    final Either<Failure, PlansModel> postsEither =
    await repo.fetchAllPlans();

    postsEither.fold(
          (failure) {
        print("in fail");
        print("in ${failure.toString()}");
        emit(PlansError(failure.toString()));
      },
          (postsList) {
        print("in success");
        emit(PlansLoaded(postsList));
      },
    );
  }
}
