import 'package:flutter/material.dart';

class ArrowButton extends StatefulWidget {
  final int turns;
  final VoidCallback  onTapDown;
  final VoidCallback  onTapUp;
  final bool isForward;
  const ArrowButton({Key? key, required this.turns,required this.onTapDown, required this.onTapUp, required this.isForward}) : super(key: key);

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<ArrowButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // highlightColor: Colors.white,
      splashColor: widget.isForward?Colors.grey[700]:Color.fromARGB(255, 105, 106, 45),
      // onTap:widget.sendData,
      borderRadius: BorderRadius.circular(10),
      onTapDown: (data){
        // print("tapped down");
        widget.onTapDown();
      },
      onTapUp: (data){
        widget.onTapUp();
      },
      child: RotatedBox(
                quarterTurns: widget.turns,
                child: Container(
                  height: 110,
                  width: 150,
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/arrow_black.png")
                    )
                  ),
                )
              ),
    );
  }
}