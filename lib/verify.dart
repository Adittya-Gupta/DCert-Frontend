import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:web_three_app/Button.dart';
import 'package:http/http.dart' as http;
import 'package:web_three_app/box.dart';
import 'package:web_three_app/main.dart';
import 'package:web_three_app/profileOverview.dart';

class VerifyPage extends StatefulWidget {
  @override
  State<VerifyPage> createState() => _VerifyPage();
}

class _VerifyPage extends State<VerifyPage> {
  TextEditingController emailController = TextEditingController();
  FilePickerResult? result;
  bool isUploaded = false;
  void handleFilePicker() async {
    result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        isUploaded = true;
      });
    } else {
      // User canceled the picker
    }
  }
  void handleUpload(url) async {
    final result = this.result;
    if (result != null) {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath(
          'file', result.files.single.path ?? ''));
      request.fields['email'] = emailController.text;
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      print("sending request");
      print(response.body);
    } else {
      // User hasn't selected a file
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Verify Certificates',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Centauri')),
            const SizedBox(height: 50),
            ProfileOverview(image: Lottie.asset('lib/assets/lottie/verification.json', width: 125, height: 125,)),
            const SizedBox(height: 100),
            Mybox(
              color: Theme.of(context).colorScheme.primary,
              height:60,
              child:const Text('Enter email of the issuer to verify the certificate',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Exo',
                )),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              height: 40,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'email',
                ),
              ),
            ),
            const SizedBox(height: 30),
            MyButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: () =>
                  handleFilePicker(),
              text: 'Upload Certificate',
              icon: Icons.upload,
            ),
            const SizedBox(height: 30),
            MyButton(
              color: isUploaded ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withOpacity(0.5),
              width: 400,
              onPressed: () => isUploaded ?
                  handleUpload("https://siangkriti.eu.pythonanywhere.com/verify") : null,
              text: 'Verify',
              icon: Icons.verified,
            )

          ],
        ),
      ),
    ));
  }
}
