import 'package:flutter/material.dart';

class Mybox extends StatelessWidget{
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  const Mybox({Key? key, this.child, this.color, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}