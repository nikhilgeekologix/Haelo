import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/profileupdate_state.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/profileupdate_data_source.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  final ProfileUpdateDataSource dataSource;
  ProfileUpdateCubit(this.dataSource) : super(ProfileUpdateInitial());

  void fetchProfileUpdate(Map<String, String> body) {
    emit(ProfileUpdateLoading());
    dataSource.fetchProfileUpdate(body).then((value) => {emit(ProfileUpdateLoaded(value))});
  }
}
