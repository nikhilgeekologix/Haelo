import 'package:dartz/dartz.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/display_board_data_source.dart';
import 'package:haelo_flutter/features/home_page/data/datasource/home_mytask_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class DisplayBoardRepository {
  Future<Either<Failure, String>> fetchDisplayBoard(Map<String, String> body);
}

class DisplayBoardRepositoryImpl implements DisplayBoardRepository {
  final NetworkInfo networkInfo;
  final DisplayBoardDataSource dataSource;

  const DisplayBoardRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchDisplayBoard(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchDisplayBoard(body);
        return Right(remoteCL.toString());
      }
      on UnauthorisedException catch (e) {
        print("status code??? repository unauthorized");
        FBroadcast.instance().broadcast("unauthorized");
        // navigationKey!.currentState!.pushNamed('/login');
        print(e.message );
        throw e;
      }
      on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
