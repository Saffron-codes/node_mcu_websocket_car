import 'package:car/websocket_service/web_socket_service.dart';
import 'package:car/widgets/arrow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/io.dart';

class HomePage extends StatefulWidget {
  final WebSocketService webSocketService;
  const HomePage({Key? key, required this.webSocketService}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isForward = true;
  double sliderValue = 0.0;
  bool isLeft = false;
  bool isRight = false;
  bool isOff = false;

  void sendData() {
    widget.webSocketService.sendData(
      '{"isforward":${isForward ? '1' : '0'},"isleft":${isLeft ? '1' : '0'},"isright":${isRight ? '1' : '0'},"speed":${sliderValue.toString()}}',
    );
  }

  void initWebSocket() {
    try {
      IOWebSocketChannel.connect(
        Uri.parse('ws://192.168.4.1:81'),
      );
      print("Connected !!");
    } catch (e) {
      print("Error connecting : $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.webSocketService.channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.portraitUp,
    // ]);

    return Scaffold(
      backgroundColor:
          isForward ? Color(0xff6b6b6b) : Color.fromARGB(255, 151, 152, 64),
      body: Stack(
        // height: MediaQuery.of(context).size.height,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // color: Colors.blue,
                width: MediaQuery.of(context).size.width * 8 / 100,
                height: 46,
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 136, 137, 59),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    sliderValue.toInt().toString(),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Transform.scale(
                    scaleX: 1.01,
                    scaleY: 1.2,
                    child: Slider(
                      activeColor: Colors.orangeAccent,
                      inactiveColor: Colors.orange[100],
                      value: sliderValue,
                      min: 0.0,
                      max: 255.0,
                      onChanged: (val) {
                        setState(
                          () {
                            sliderValue = val;
                          },
                        );
                      },
                      onChangeEnd: (val) {
                        sendData();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 150,
            left: MediaQuery.of(context).size.width * 45 / 100,
            child: Transform.scale(
              scale: 1.6,
              child: Switch(
                activeColor: Color.fromARGB(255, 153, 104, 40),
                inactiveThumbColor: Colors.orange[100],
                inactiveTrackColor: Colors.orange[300],
                value: isOff,
                onChanged: (val) {
                  setState(() {
                    isOff = !isOff;
                    sliderValue = 0.0;
                  });
                  sendData();
                },
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: MediaQuery.of(context).size.width * 45 / 100,
            child: Transform.scale(
              scale: 2.0,
              child: Row(
                children: [
                  Text("R"),
                  Switch(
                    activeColor: Colors.orangeAccent,
                    inactiveThumbColor: Colors.orange[100],
                    inactiveTrackColor: Colors.orange[300],
                    value: isForward,
                    onChanged: (val) {
                      setState(() {
                        isForward = val;
                        sliderValue = 0.0;
                      });
                      sendData();
                    },
                  ),
                  Text("F"),
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 58,
            child: Row(
              children: [
                //left button
                ArrowButton(
                  isForward: isForward,
                  turns: 6,
                  onTapDown: () {
                    setState(() {
                      isLeft = true;
                      isRight = false;
                    });
                    sendData();
                  },
                  onTapUp: () {
                    setState(() {
                      isLeft = false;
                      isRight = false;
                    });
                    sendData();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                //right button
                ArrowButton(
                  isForward: isForward,
                  turns: 8,
                  // sendData: () {
                  //   setState(() {
                  //     isRight = !isRight;
                  //     isLeft = false;
                  //   });
                  //   sendData();
                  // }),
                  onTapDown: () {
                    setState(() {
                      isRight = true;
                      isLeft = false;
                    });
                    sendData();
                  },
                  onTapUp: () {
                    setState(() {
                      isRight = false;
                      isLeft = false;
                    });
                    sendData();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
