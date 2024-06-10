// server exception
import 'package:equatable/equatable.dart';

class ServerException implements Exception {
  // error message
  String message;
  ServerException(this.message);
}

class BadRequestException extends ServerException {
  BadRequestException(String message) : super(message);
}

class UnauthorisedException extends ServerException {
  UnauthorisedException(String message) : super(message);
}

class DataParsingException extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}

class NoConnectionException extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}