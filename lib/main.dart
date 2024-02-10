import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_three_app/Homepage.dart';
import 'package:web_three_app/Theme/theme.dart';
import 'package:web_three_app/download.dart';
import 'package:web_three_app/verify.dart';
import 'AdminHomePage.dart';
import 'ChatPage.dart';
import 'Login.dart';


GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
bool state = false;
late final prefs;
dynamic data;
const admins = ['g.aditya@iitg.ac.in'];
late final String privateKey;
List<dynamic> urls = [];
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  final String? accessToken = await prefs.getString('access_token');
  final String? tokenExpiry = await prefs.getString('token_expiry');
  privateKey = await prefs.getString('privateKey') ?? '';
  print(privateKey);
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
    response = await dio.get("https://siangkriti.eu.pythonanywhere.com/getcerts?email='${data['mail']}'");
    urls = response.data["urls"];
  }
  else{
    state = false;
  }
  // urls = response.data["urls"];
  // runApp(MaterialApp(
  //   home: state ? MainScreen(data: data,): const LoginPage(),
  //   navigatorKey: navKey,
  // ));



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isAdmin = false;
    if (data != null) {
      for (var i in admins) {
        if (data['mail'] == i) {
          isAdmin = true;
          break;
        }
      }
    }
    return MaterialApp(
      title: 'Flutter Demo',
      home: isAdmin ? AdminHomePage(data: data) : ( state ?  MainScreen(data: data,) : const LoginPage()),
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
      DownloadPage()
    ];
  }
  PageController _pageController = PageController(initialPage: 0);
  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
  @override
  Widget build(BuildContext context) {
    void startConversation() async {
      try {
        showDialog(
            context: context,
            builder: (_) =>AlertDialog(
              title: const Text('Waking up the bot'),
              content: Lottie.asset('lib/assets/lottie/loading.json'),
            )
        );
        dynamic conversationObject = {
          'appId': '37096eb8e7331568b71e200af3046e5a9', // Replace with your Kommunicate App ID
          // You can customize this object as needed; refer to the Kommunicate documentation for more options
        };

        KommunicateFlutterPlugin.buildConversation(conversationObject)
            .then((result) {
              Navigator.pop(context);
          print("Conversation builder success: $result");
        }).catchError((error) {
          print("Conversation builder error: $error");
        });
      } catch (e) {
        print("Error occurred while building conversation: $e");
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () => startConversation(),
        child: Lottie.asset(
          'lib/assets/lottie/chatbot.json',
          width: 80,
          height: 80,
          fit: BoxFit.fill,
        )
      ),
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.tertiary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home) , label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.verified), label: 'Verify'),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Download'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: context.isDarkMode ?  Colors.transparent : const Color(0xFFFBAE1A),
      ),
    );
  }
}

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

