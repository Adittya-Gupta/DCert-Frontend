import 'package:flutter/cupertino.dart';

class MyButton extends StatelessWidget {
  final Color? color;
  final void Function()? onPressed;
  const MyButton({super.key, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(25),
        child: const Center(child:Text('Button')),
      ),
    );
  }
}
