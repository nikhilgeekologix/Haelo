import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/cubit/profile_state.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/profile_data_source.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileDataSource dataSource;
  ProfileCubit(this.dataSource) : super(ProfileInitial());

  void fetchProfile() {
    emit(ProfileLoading());
    dataSource.fetchProfile().then((value) => {emit(ProfileLoaded(value))});
  }
}
