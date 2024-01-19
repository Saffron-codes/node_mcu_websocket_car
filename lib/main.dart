import 'package:car/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

import 'websocket_service/web_socket_service.dart';

void main() async {
  final channel =  IOWebSocketChannel.connect(
    	// Node MCU Car IP
	//Uri.parse('ws://192.168.4.1:81'),
	
	//Uri.parse('ws://localhost:87')
  );
  final webSocketService = WebSocketService(channel);
  
  runApp(
    CarApp(
      webSocketService: webSocketService,
    ),
  );
}
