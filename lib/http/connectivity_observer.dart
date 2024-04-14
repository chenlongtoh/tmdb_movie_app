import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityObserver {
  static final ConnectivityObserver _singleton = ConnectivityObserver._internal();
  factory ConnectivityObserver() => _singleton;
  ConnectivityObserver._internal();

  bool connected = false;
  init() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    connected = connectivityResult != ConnectivityResult.none;

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connected = result != ConnectivityResult.none;
    });
  }
}
