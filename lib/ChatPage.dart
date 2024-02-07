import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';


class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  void startConversation() async {
    try {
      dynamic conversationObject = {
        'appId': "37096eb8e7331568b71e200af3046e5a9", // Replace with your Kommunicate App ID
        // You can customize this object as needed; refer to the Kommunicate documentation for more options
      };

      KommunicateFlutterPlugin.buildConversation(conversationObject)
          .then((result) {
        print("Conversation builder success: $result");
      }).catchError((error) {
        print("Conversation builder error: $error");
      });
    } catch (e) {
      print("Error occurred while building conversation: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Us"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: startConversation,
          child: Text('Start Chat'),
        ),
      ),
    );
  }
}

