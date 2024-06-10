import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/core/utils/exceptions.dart';
import 'package:haelo_flutter/core/utils/failures.dart';
import 'package:haelo_flutter/core/utils/network_info.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/update_display_board_datasource.dart';

abstract class UpdateDisplayBoardRepository {
  Future<Either<Failure, String>> updateDisplayBoard(Map<String, String> body);
}

class UpdateDisplayBoardRepositoryImpl implements UpdateDisplayBoardRepository {
  final NetworkInfo networkInfo;
  final UpdateDisplayBoardDataSource dataSource;

  const UpdateDisplayBoardRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> updateDisplayBoard(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.updateDisplayBoard(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
