import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/aboutus_data_source.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/commentshistory_data_source.dart';
import 'aboutus_state.dart';
import 'commentshistory_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  final AboutUsDataSource dataSource;
  AboutUsCubit(this.dataSource) : super(AboutUsInitial());

  void fetchAboutUs() {
    emit(AboutUsLoading());
    dataSource.fetchAboutUs().then((value) => {emit(AboutUsLoaded(value))});
  }
}
