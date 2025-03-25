// controllers/websocket_controller.dart
import 'package:get/get.dart';

import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketController<T> extends GetxController {
  late WebSocketChannel _channel;
  final Rx<T?> _data = Rx<T?>(null);
  final RxString _error = RxString('');
  final T Function(Map<String, dynamic>) fromJson;

  T? get data => _data.value;

  String get error => _error.value;

  WebSocketController({required this.fromJson}) {
    _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.0.52:18080'));
    _channel.stream.listen(
      (rawData) => _handleData(rawData),
      onError: (err) => _error.value = '連線錯誤: $err',
      onDone: () => _error.value = '連線已關閉',
    );
  }

  void _handleData(dynamic rawData) {
    try {
      final json = jsonDecode(rawData);
      _data.value = fromJson(json);
      _error.value = '';
    } catch (e) {
      _error.value = '解析錯誤: $e';
    }
  }

  void sendJson(Map<String, dynamic> json) {
    final message = jsonEncode(json);
    _channel.sink.add(message);
  }

  @override
  void onClose() {
    _channel.sink.close();
    super.onClose();
  }
}
