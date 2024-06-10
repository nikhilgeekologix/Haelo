import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/createwatchlist_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class CreateWatchlistRepository {
  Future<Either<Failure, String>> fetchCreateWatchlist(Map<String, String> body);
}

class CreateWatchlistRepositoryImpl implements CreateWatchlistRepository {
  final NetworkInfo networkInfo;
  final CreateWatchlistDataSource dataSource;

  const CreateWatchlistRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchCreateWatchlist(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchCreateWatchlist(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
