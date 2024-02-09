import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color? color;
  final void Function()? onPressed;
  final String text;
  final IconData? icon;
  final double? width;
  const MyButton({super.key, this.color, this.onPressed, required this.text, this.icon, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? 250,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),

        child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(icon != null) Icon(icon),
                const SizedBox(width: 10,),
                Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Exo')),
              ],
            )),
    );
  }
}
