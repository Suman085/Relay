import 'package:flutter/material.dart';
import 'package:relay/relay.dart';

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
  late MyWebSocketClient _webSocketClient;
  String message = "";

  @override
  void initState() {
    super.initState();
    _webSocketClient = MyWebSocketClient('ws://lively-field-7351.sharif-ghazzawi.workers.dev/websocket');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text(
            "To tcpClient : $message",
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webSocketClient.dispose();
    super.dispose();
  }
}
