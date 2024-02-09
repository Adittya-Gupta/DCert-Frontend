import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:web_three_app/main.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: context.isDarkMode
                  ? const AssetImage("lib/assets/images/dark-background.png")
                  : const AssetImage("lib/assets/images/light-background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ElevatedButton(
              onPressed: null,
              child: Text('Start Chat'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.orangeAccent)),
            ),
          ),
        ));
  }
}
