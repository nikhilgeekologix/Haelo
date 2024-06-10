import 'package:bloc/bloc.dart';
import '../data/datasource/splash_data_source.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final SplashRemoteDataSource splashRemoteDataSource;
  SplashCubit(this.splashRemoteDataSource) : super(SplashInitial());

  void fetchConfig(Map<String, String> map)
  {
    splashRemoteDataSource.fetchConfig(map).then((value) => {
       emit(SplashLoaded(value))
    });
  }
}
