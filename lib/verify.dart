
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_three_app/Button.dart';
import 'package:http/http.dart' as http;
class VerifyPage extends StatefulWidget {

  @override
  State<VerifyPage> createState()  => _VerifyPage();

}

class _VerifyPage extends State<VerifyPage> {

  void handleUpload(url) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('file', result.files.single.path ?? ''));
      var res = await request.send();
      print(res);
    } else {
      // User canceled the picker
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Verify Certificates',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Centauri')),
            const SizedBox(height: 150),
            const Text('Enter email of the issuer to verify the certificate',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20),
            const SizedBox(
              width: 250,
              height: 40,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 30),
            MyButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () => handleUpload("http://14.139.196.245:3000/test"),
            )
          ],
        ),
      ),
    );
  }
}
