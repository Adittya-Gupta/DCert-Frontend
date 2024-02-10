import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:aad_oauth/model/failure.dart';
import 'package:aad_oauth/model/token.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:web_three_app/AdminHomePage.dart';
import 'package:web_three_app/Button.dart';
import 'package:web_three_app/Homepage.dart';
import 'package:web_three_app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final microsoftSignIn = AadOAuth(Config(
      // If you dont have a special tenant id, use "common"
      tenant: "850aa78d-94e1-4bc6-9cf3-8c11b530701c",
      clientId: "06b52b44-dbef-43ca-949f-5f6a0e846649",
      // Replace this with your client id ("Application (client) ID" in the Azure Portal)
      responseType: "code",
      scope: "User.Read",
      redirectUri: "msal06b52b44-dbef-43ca-949f-5f6a0e846649://auth",
      loader: const Center(child: CircularProgressIndicator()),
      navigatorKey: navKey,
    ));
    getUserInfo(token) async {
      Response response;
      Dio dio = Dio();
      response = await dio.get('https://graph.microsoft.com/v1.0/me',
          options: Options(headers: {
            HttpHeaders.authorizationHeader: '$token',
          }));

      return response.data;
    }
    getPrivatekey() async {
      Response response;
      Dio dio = Dio();
      response = await dio.get("https://siangkriti.eu.pythonanywhere.com/getkeys?email='${data['mail']}'");
      print(response.data);
      var x =  response.data;
      print(x);
      return x['pri'];
    }
    loginWithMicrosoft() async {
      var result = await microsoftSignIn.login();

      result.fold(
        (Failure failure) {
          // Auth failed, show error
          log(failure.toString());
        },
        (Token token) async {
          if (token.accessToken == null) {
            // Handle missing access token, show error or whatever
            log('Access token is null');
            return;
          }
          // Handle successful login
          showDialog(
              context: context,
              builder: (_) =>AlertDialog(
                title: const Text('Let us set up your account'),
                content: Lottie.asset('lib/assets/lottie/loading.json'),
              )
          );
          // Perform necessary actions with the access token, such as API calls or storing it securely.
          var userInfo = await getUserInfo(token.accessToken);
          data = userInfo;
          Response response;
          Dio dio = Dio();
          var privateKey = await prefs.getString('privateKey');
          print("lksdlfsd");
          if (privateKey == null) {
            privateKey = await getPrivatekey();
            print(privateKey);
            await prefs.setString('privateKey', privateKey);
          }
          print("hsdlkflsdjflksdjf");
          response = await dio.get("https://siangkriti.eu.pythonanywhere.com/getcerts?email='${userInfo['mail']}'");
          print("sldkfsldkflsd");
          urls = response.data["urls"];
          for (var i in admins) {
            if (data['mail'] == i) {
              isAdmin = true;
              break;
            }
          }
          await prefs.setString('access_token', token.accessToken);
          await prefs.setString('token_expiry',
              DateTime.now().add(const Duration(hours: 1)).toIso8601String());

          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => isAdmin ?  AdminHomePage(data: userInfo) : MainScreen(data: userInfo),
            ),
          );
          await microsoftSignIn.logout();
        },
      );
    }

    // Scaffold is a layout for the major Material Components.
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/images/login.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50,),
          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("lib/assets/images/logow.png"),
                width: 50,
                height: 50,
              ),
              Spacer(),
              Text('Login',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Exo')),
            ],
          ),),
          const SizedBox(height: 200),
          const Text('Make your',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Exo')),
          const Text('grade',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Exo')),
          const Text('Card',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Exo')),
          const Text('Secure!',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Exo')),
          const SizedBox(height: 70,),
          MyButton(
              color: const Color(0xE23372c7),
              onPressed: () => loginWithMicrosoft(),
          text: 'Login with Outlook',
          image: SvgPicture.asset('lib/assets/icons/outlook.svg', width: 30, height: 30),
          )
        ],
      )),
    ));
  }
}
