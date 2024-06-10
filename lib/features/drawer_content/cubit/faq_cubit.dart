import 'package:bloc/bloc.dart';
import 'package:haelo_flutter/features/drawer_content/data/datasource/faq_data_source.dart';
import 'faq_state.dart';

class FAQCubit extends Cubit<FAQState> {
  final FAQDataSource dataSource;
  FAQCubit(this.dataSource) : super(FAQInitial());

  void fetchFAQ() {
    emit(FAQLoading());
    dataSource.fetchFAQ().then((value) => {emit(FAQLoaded(value))});
  }
}
