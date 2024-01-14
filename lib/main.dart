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
  String message = "";

  @override
  void initState() {
    super.initState();
    initWebSocketClients(4);
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
            const ConnectivityPage(title: "Connectivity Page"),
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

  @override
  void dispose() {
    for (var client in _webSocketClients) {
      client.dispose();
    }
    super.dispose();
  }
}
