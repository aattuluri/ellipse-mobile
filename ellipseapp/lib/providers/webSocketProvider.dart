import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

import '../util/index.dart';

WebSocketsConnection sockets = new WebSocketsConnection();

class WebSocketsConnection {
  static final WebSocketsConnection _socket =
      new WebSocketsConnection._internal();

  factory WebSocketsConnection() {
    return _socket;
  }

  WebSocketsConnection._internal();
  IOWebSocketChannel _channel;

  ObserverList<Function> _listeners = new ObserverList<Function>();
  Future<void> connect() async {
    await reset();
    await initWebSocketChannel();
  }

  Future<void> initWebSocketChannel() async {
    try {
      _channel = new IOWebSocketChannel.connect('${Url.WEBSOCKET_URL}');
      print(_channel);
      _channel.stream.listen(onMessage, onDone: reConnect, cancelOnError: true);
    } catch (e) {
      print(e);
    }
  }

  Future<void> reConnect() async {
    await initWebSocketChannel();
  }

  Future<void> reset() {
    _listeners.forEach((element) {
      _listeners.remove(element);
    });
  }

  send(String message) async {
    if (_channel != null) {
      if (_channel.sink == null) {
        await reConnect();
        _channel.sink.add(message);
      } else {
        _channel.sink.add(message);
      }
    } else {
      await reConnect();
      _channel.sink.add(message);
    }
    print('message sent');
  }

  onMessage(message) {
    _listeners.forEach((Function callback) {
      callback(message);
      print('message received');
    });
  }

  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }
}
