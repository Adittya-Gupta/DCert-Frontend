import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:web_three_app/box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.data});
  final data;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Home',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Centauri')),
          const SizedBox(height: 150),
          Mybox(
            color: Colors.white30,
            width: 200,
            height: 200,
            child: Image.asset("lib/assets/images/pfp_blank.png"),
          ),
          const SizedBox(height: 70),
          const Text('Name', style: TextStyle(fontSize: 15)),
          const SizedBox(height: 10),
          Mybox(
              color: Theme.of(context).colorScheme.primary,
              width: 250,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  ),
                  Text(' ${widget.data['givenName']}'),
                ],
              )),
          const SizedBox(height: 20),
          const Text('Roll No.', style: TextStyle(fontSize: 15)),
          const SizedBox(height: 10),
          Mybox(
              color: Theme.of(context).colorScheme.primary,
              width: 250,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.numbers,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  ),
                  Text(' ${widget.data['surname']}'),
                ],
              ))
        ],
      )),
    );
  }
}
