import 'package:car/pages/home_page.dart';
import 'package:car/pages/new_home_page.dart';
import 'package:car/websocket_service/web_socket_service.dart';
import 'package:flutter/material.dart';

class CarApp extends StatelessWidget {
  final WebSocketService webSocketService;
  const CarApp({Key? key, required this.webSocketService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Colors.orange
      ),
      debugShowCheckedModeBanner: false,
      home: NewHomePage(
        webSocketService: webSocketService,
      )
    );
  }
}