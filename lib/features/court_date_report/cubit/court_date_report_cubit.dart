import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haelo_flutter/features/court_date_report/cubit/court_date_report_state.dart';
import 'package:haelo_flutter/features/court_date_report/data/datasource/court_date_report_datasource.dart';

// class CourtDateReportCubit extends Cubit<CourtDateReportState> {
//   final CourtDateReportRepository repo;
//
//   CourtDateReportCubit(
//     this.repo,
//   ) : super(CourtDateReportInitial());
//
//   Future<void> fetchCourtDateReport(Map<String, String>? body) async {
//     emit(CourtDateReportLoading());
//     final Either<Failure, CourtDateReportModel> postsEither =
//         await repo.fetchCourtDateReport(body);
//     postsEither.fold(
//       (failure) {
//         print("in fail");
//         print("in ${failure.toString()}");
//         emit(CourtDateReportError(failure.toString()));
//       },
//       (postsList) {
//         print("in success");
//         emit(CourtDateReportLoaded(postsList));
//       },
//     );
//   }
// }

class CourtDateReportCubit extends Cubit<CourtDateReportState> {
  final CourtDateReportDataSource dataSource;
  CourtDateReportCubit(this.dataSource) : super(CourtDateReportInitial());

  void fetchCourtDateReport(Map<String, String> body) {
    emit(CourtDateReportLoading());
    dataSource.fetchCourtDateReport(body).then((value) => {emit(CourtDateReportLoaded(value))});
  }
}


