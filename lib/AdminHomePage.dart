import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_three_app/main.dart';
import 'Button.dart';
import 'box.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key, this.data});
  final data;
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
  TextEditingController emailController = TextEditingController();
  void handleUpload(url) async {
    final result = this.result;
    if (result != null) {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath(
          'file', result.files.single.path ?? ''));
      request.fields['remail'] = emailController.text;
      request.fields['omail'] = widget.data['mail'];
      request.fields['docname'] = "certificate";
      print(request.fields);
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
          const Text('Admin Home',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Centauri')),
          const SizedBox(height: 70),
          Text('Hello, ${widget.data['givenName']}',
              style: const TextStyle(fontSize: 15, fontFamily: 'Exo')),
          const SizedBox(height: 70),
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
                hintText: 'abc.def@iitg.ac.in',
              ),
            ),
          ),
          const SizedBox(height: 30),
          MyButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () =>
                handleFilePicker(),
            text: 'Upload certificate',
            icon: Icons.upload,
          ),
          const SizedBox(height: 70,),
          MyButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () =>
                handleUpload("https://siangkriti.eu.pythonanywhere.com/add"),
            text: 'Issue',
            icon: Icons.file_download_done_outlined,
          ),
        ],
      )),
    ));
  }
}
