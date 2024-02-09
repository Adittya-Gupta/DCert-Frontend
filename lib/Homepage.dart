import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:lottie/lottie.dart';
import 'package:web_three_app/box.dart';
import 'package:web_three_app/main.dart';

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
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: context.isDarkMode ? const AssetImage("lib/assets/images/dark-background.png") : const AssetImage("lib/assets/images/light-background.png"),
            fit: BoxFit.cover,
          ),
        ),
      child: Center(
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
            child: Lottie.asset('lib/assets/lottie/person.json')
          ),
          const SizedBox(height: 70),
          const Text('Name', style: TextStyle(fontSize: 15, fontFamily: 'Exo', fontWeight: FontWeight.bold)),
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
                  Text(' ${widget.data['givenName']}', style: const TextStyle(fontFamily: 'Exo')),
                ],
              )),
          const SizedBox(height: 20),
          const Text('Roll No.', style: TextStyle(fontSize: 15, fontFamily: 'Exo', fontWeight: FontWeight.bold)),
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
                  Text(' ${widget.data['surname']}', style: const TextStyle(fontFamily: 'Exo')),
                ],
              ))
        ],
      )),
    ));
  }
}
