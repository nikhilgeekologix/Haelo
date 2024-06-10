import 'package:dartz/dartz.dart';
import 'package:haelo_flutter/features/causeslist/data/datasource/viewandsave_data_source.dart';
import '../../../../core/utils/exceptions.dart';
import '../../../../core/utils/failures.dart';
import '../../../../core/utils/network_info.dart';

abstract class ViewSaveRepository {
  Future<Either<Failure, String>> fetchViewSave(Map<String, String> body);
}

class ViewSaveRepositoryImpl implements ViewSaveRepository {
  final NetworkInfo networkInfo;
  final ViewSaveDataSource dataSource;

  const ViewSaveRepositoryImpl({required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Failure, String>> fetchViewSave(Map<String, String> body) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCL = await dataSource.fetchViewSave(body);
        return Right(remoteCL.toString());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(InternetFailure());
    }
  }
}
