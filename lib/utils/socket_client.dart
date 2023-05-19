import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = IO.io('SERVER IP', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.onConnectError((data) {
      print("Error Connecting - > $data");
    });
    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
