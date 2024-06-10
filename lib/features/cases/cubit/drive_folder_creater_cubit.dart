import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/cases/data/datasource/addcomment_data_source.dart';
import '../data/datasource/drive_folder_creater_data_source.dart';
import 'addcomment_state.dart';
import 'drive_folder_creater_state.dart';

class DriveFolderCreatorCubit extends Cubit<DriveFolderCreatorState> {
  final DriveFolderCreatorDataSource dataSource;
  DriveFolderCreatorCubit(this.dataSource) : super(DriveFolderCreatorInitial());

  void fetchAddComment(Map<String, String> body) {
    emit(DriveFolderCreatorLoading());
    dataSource
        .fetchDriveFolderCreator(body)
        .then((value) => {emit(DriveFolderCreatorLoaded(value))});
  }
}
