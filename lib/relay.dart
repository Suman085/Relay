import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

class MyWebSocketClient {
  late WebSocketChannel _wsChannel;
  Socket? _tcpClient;

  MyWebSocketClient(String url) {
    _wsChannel = WebSocketChannel.connect(
      Uri.parse(url),
    );

    _wsChannel.stream.listen((dynamic data) {
      handleWebSocketData(data);
    });
  }

  void handleWebSocketData(dynamic data) {
    String request = String.fromCharCodes(data);
    print(request);
    if (request.startsWith('CONNECT ')) {
      _handleConnectRequest(request);
    } else {
      _handleRegularRequest(data);
    }
  }

  void _handleConnectRequest(String request) {
    const String httpResponse = 'HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n';
    final List<String> hostAndPort = getHostAndPort(request);
    final String host = hostAndPort[0];
    final int port = int.parse(hostAndPort[1]);

    Socket.connect(host, port).then((Socket tcpClient) {
      print('Connected to server!');
      _tcpClient = tcpClient;
      _tcpClient?.listen((Uint8List data) {
        _sendToWebSocket(data);
      });
      _wsChannel.sink.add(utf8.encode(httpResponse));
    });
  }

  void _handleRegularRequest(dynamic data) {
    if (_tcpClient != null) {
      _tcpClient?.add(data);
    }
  }

  void _sendToWebSocket(Uint8List data) {
    _wsChannel.sink.add(data);
  }

  List<String> getHostAndPort(String request) {
    final List<String> lines = request.split('\r\n');
    final String hostLine = lines.firstWhere((line) => line.startsWith('Host:'), orElse: () => '');
    final List<String> parts = hostLine.split(':');
    return [parts[1].trim(), parts[2].trim()];
  }

  void dispose() {
    _wsChannel.sink.close();
    _tcpClient?.close();
  }
}