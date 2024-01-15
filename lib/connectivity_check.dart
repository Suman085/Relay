import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class ConnectivityListener {
  final Connectivity _connectivity = Connectivity();
  late StreamController<ConnectivityResult> _controller;

  ConnectivityListener() {
    _controller = StreamController<ConnectivityResult>.broadcast();
    _initConnectivity();
  }

  Stream<ConnectivityResult> get connectivityStream => _controller.stream;

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!_controller.isClosed) {
      _controller.add(result);
    }

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (!_controller.isClosed) {
        _controller.add(result);
      }
    });
  }

  void dispose() {
    _controller.close();
  }
}