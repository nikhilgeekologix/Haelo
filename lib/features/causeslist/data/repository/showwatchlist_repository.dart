import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/showwatchlist_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class ShowWatchlistRepository {
  Future<Either<Failure, String>> fetchShowWatchlist();
}

class ShowWatchlistRepositoryImpl implements ShowWatchlistRepository {
  final NetworkInfo networkInfo;
  final ShowWatchlistDataSource dataSource;

  const ShowWatchlistRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchShowWatchlist() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchShowWatchlist();
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
