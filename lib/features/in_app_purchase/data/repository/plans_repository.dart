import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/datasource/plans_datasource.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/my_subscription_model.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/pay_request_model.dart';
import 'package:haelo_flutter/features/in_app_purchase/data/model/plans_model.dart';

abstract class PlansRepository {
  Future<Either<Failure, PlansModel>> fetchAllPlans();
  Future<Either<Failure, MySubscriptionModel>> fetchMySubscription();
  Future<Either<Failure, PayRequestModel>> payRequest(Map<String, String> data);
}

class PlansRepositoryImpl implements PlansRepository {
  final NetworkInfo networkInfo;
  final PlansDataSource dataSource;

  const PlansRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, PlansModel>> fetchAllPlans() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchAllPlans();
        return Right(remoteCL);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  @override
  Future<Either<Failure, MySubscriptionModel>> fetchMySubscription() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchMySubscription();
        return Right(remoteCL);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }

  Future<Either<Failure, PayRequestModel>> payRequest(
      Map<String, String> data) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.payRequest(data);
        return Right(remoteCL);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
