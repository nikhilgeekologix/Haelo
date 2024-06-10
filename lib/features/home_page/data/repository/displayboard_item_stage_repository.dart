import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/displayboard_summary_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';
import '../datasource/displayboard_itemstage_data_source.dart';

abstract class DisplayBoardStageItemRepository {
  Future<Either<Failure, String>> fetchDisplayBoardStageItem(
      Map<String, String> body);
}

class DisplayBoardStageItemRepositoryImpl
    implements DisplayBoardStageItemRepository {
  final NetworkInfo networkInfo;
  final DisplayBoardItemStageDataSource dataSource;

  const DisplayBoardStageItemRepositoryImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchDisplayBoardStageItem(
      Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchDisplayBoardItemStage(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
