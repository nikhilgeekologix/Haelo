import 'package:equatable/equatable.dart';

// generic class for failures
abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// server failure
class ServerFailure extends Failure {
  final String message;

  ServerFailure(this.message);
}

// Not allowed Failure
class NotAllowedFailure extends Failure {
  final String message;
  NotAllowedFailure(this.message);
}

// Auth failure
class AuthFailure extends Failure {
  final String message;

  AuthFailure(this.message);
}

// input failure
class InputFailure extends Failure {
  final String message;

  InputFailure(this.message);
}

// data failure
class DataFailure extends Failure {
  final String message;

  DataFailure(this.message);
}

// cache failure
class CacheFailure extends Failure {
  final String message;

  CacheFailure(this.message);
}

// internet failure
//
// will occur when device is offline
class InternetFailure extends Failure {}
