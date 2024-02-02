import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_three_app/Homepage.dart';
import 'package:web_three_app/Theme/theme.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: state ?  HomePage(data: data) : const LoginPage(),
      theme: lightMode,
      darkTheme: darkMode,
      navigatorKey: navKey,
    );
  }
}