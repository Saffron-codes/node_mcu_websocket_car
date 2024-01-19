import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService{
  IOWebSocketChannel channel;
  
  WebSocketService(this.channel);

  void sendData(String data){
    channel.sink.add(data);
  }
}