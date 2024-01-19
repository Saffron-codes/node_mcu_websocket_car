import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../websocket_service/web_socket_service.dart';

class NewHomePage extends StatefulWidget {
  final WebSocketService webSocketService;
  const NewHomePage({Key? key, required this.webSocketService})
      : super(key: key);

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  bool isForward = false;
  bool isBackward = false;
  bool isLeft = false;
  bool isRight = false;
  double sliderValue = 0.0;

  void sendData() {
    widget.webSocketService.sendData(
      '{"isforward":${isForward ? '1' : '0'},"isbackward":${isBackward ? '1' : '0'},"isleft":${isLeft ? '1' : '0'},"isright":${isRight ? '1' : '0'},"speed":${sliderValue.toString()}}',
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Material(
      color: Color(0xFF6B6B6B),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  // height: 100,
                  // color: Colors.amber,
                  margin: EdgeInsets.only(left: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blue,
                          child: InkWell(
                            onTapDown: (val) {
                              setState(() {
                                isForward = true;
                                isBackward = false;
                              });
                              sendData();
                            },
                            onTapUp: (val) {
                              setState(() {
                                isForward = false;
                                isBackward = false;
                              });
                              sendData();
                            },
                            child: SizedBox(
                                width: 160,
                                height: 160,
                                child: Icon(
                                  Icons.arrow_upward,
                                  size: 80,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          color: Colors.blue,
                          child: InkWell(
                            onTapDown: (val) {
                              setState(() {
                                isBackward = true;
                                isForward = false;
                              });
                              sendData();
                            },
                            onTapUp: (val) {
                              setState(() {
                                isBackward = false;
                                isForward = false;
                              });
                              sendData();
                            },
                            child: SizedBox(
                              width: 160,
                              height: 160,
                              child: Icon(
                                Icons.arrow_downward,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                // height: 100,
                width: 400,
                // margin: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.blue,
                        child: InkWell(
                          onTapDown: (val) {
                            setState(() {
                              isLeft = true;
                              isRight = false;
                            });
                            sendData();
                          },
                          onTapUp: (val) {
                            setState(() {
                              isLeft = false;
                              isRight = false;
                            });
                            sendData();
                          },
                          child: SizedBox(
                              width: 160,
                              height: 160,
                              child: Icon(
                                Icons.arrow_back,
                                size: 80,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.blue,
                        child: InkWell(
                          onTapDown: (val) {
                            setState(() {
                              isRight = true;
                              isLeft = false;
                            });
                            sendData();
                          },
                          onTapUp: (val) {
                            setState(() {
                              isRight = false;
                              isLeft = false;
                            });
                            sendData();
                          },
                          child: SizedBox(
                            width: 160,
                            height: 160,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              // top: 150,
              left: MediaQuery.of(context).size.width * 30 / 100,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // color: Colors.blue,s
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
