import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:relay/connectivity_check.dart';
import 'package:relay/my_web_socket_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late final List<MyWebSocketClient> _webSocketClients = [];
  late ConnectivityListener _connectivityListener;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String message = "";

  @override
  void initState() {
    super.initState();
    initWebSocketClients(4);
    _connectivityListener = ConnectivityListener();
    _connectivitySubscription =
        _connectivityListener.connectivityStream.listen(_updateConnectionStatus);
  }

  void initWebSocketClients(int numberOfClients){
    for (int i = 1; i <= numberOfClients; i++) {
      String url = 'ws://localhost:7001'; // Modify the URL as needed
      MyWebSocketClient client = MyWebSocketClient(url);
      _webSocketClients.add(client);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                "To tcpClient : $message",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    // Handle the connectivity result, update UI, or take actions as needed
    // For example, you can set a state variable to display the connectivity status.
    print('Connection Status: $result');
    // switch(result.name){
    //   case result.
    // }
   switch(result){
     case ConnectivityResult.wifi:
     // TODO: Handle this case.
     case ConnectivityResult.mobile:
       // TODO: Handle this case.
     case ConnectivityResult.bluetooth:
       // TODO: Handle this case.
     case ConnectivityResult.ethernet:
       // TODO: Handle this case.
     case ConnectivityResult.none:
       // TODO: Handle this case.
     case ConnectivityResult.vpn:
       // TODO: Handle this case.
     case ConnectivityResult.other:
       // TODO: Handle this case.
   }
  }

  @override
  void dispose() {
    for (var client in _webSocketClients) {
      client.dispose();
    }
    _connectivitySubscription.cancel();
    _connectivityListener.dispose();
    super.dispose();
  }
}
