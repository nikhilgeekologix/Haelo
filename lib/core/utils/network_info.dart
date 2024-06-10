import 'package:data_connection_checker/data_connection_checker.dart';

// generic class for getting network information
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// network info implementation
class NetworkInfoImpl implements NetworkInfo {
  // data connection checker package
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
