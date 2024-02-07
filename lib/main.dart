import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_three_app/Homepage.dart';
import 'package:web_three_app/Theme/theme.dart';
import 'package:web_three_app/download.dart';
import 'package:web_three_app/verify.dart';
import 'ChatPage.dart';
import 'Login.dart';


GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
bool state = false;
late final prefs;
dynamic data;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  final String? accessToken = await prefs.getString('access_token');
  final String? tokenExpiry = await prefs.getString('token_expiry');
  if (accessToken != null && tokenExpiry != null && DateTime.tryParse(tokenExpiry)!.isAfter(DateTime.now())) {
    // Token is valid, proceed with automatic login
    state = true;
    Response response;
    Dio dio = Dio();
    response = await dio.get(
        'https://graph.microsoft.com/v1.0/me',
        options: Options(
            headers: {
              HttpHeaders.authorizationHeader: accessToken,
            }));
    data = response.data;
  }
  else{
    state = false;
  }
<<<<<<< HEAD
  // runApp(MaterialApp(
  //   home: state ? MainScreen(data: data,): const LoginPage(),
  //   navigatorKey: navKey,
  // ));

=======
>>>>>>> 870748fee6328fcae489e9e4f26d5d405069322d
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: state ?  MainScreen(data: data) : const LoginPage(),
      theme: lightMode,
      darkTheme: darkMode,
      navigatorKey: navKey,
    );
  }
}

class MainScreen extends StatefulWidget {
  final dynamic data; // Assuming you pass the necessary data for the HomePage

  const MainScreen({Key? key, this.data}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(data: widget.data),
      VerifyPage(),
      DownloadPage(),
      ChatPage(), // You'll need to create this page
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemYellow,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.tertiary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home) , label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.verified), label: 'Verify'),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Download'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.yellow
      ),
    );
  }
}

