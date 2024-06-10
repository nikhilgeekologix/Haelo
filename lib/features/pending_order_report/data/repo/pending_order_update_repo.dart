import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/displayboard_summary_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/pending_order_download_file_source.dart';
import '../datasource/pending_order_report_source.dart';
import '../datasource/pending_order_update_source.dart';

abstract class PendingOrderUpdateRepository {
  Future<Either<Failure, String>> fetchPendingOrderUpdate(
      Map<String, String> body);
}

class PPendingOrderUpdateRepositoryImpl
    implements PendingOrderUpdateRepository {
  final NetworkInfo networkInfo;
  final PendingOrderUpdateSource dataSource;

  const PPendingOrderUpdateRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchPendingOrderUpdate(
      Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchPendingOrderUpdate(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
