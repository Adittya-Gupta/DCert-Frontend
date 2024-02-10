import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
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
      print("saldflksd");
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath(
          'file', result.files.single.path ?? ''));
      request.fields['remail'] = emailController.text;
      request.fields['omail'] = widget.data['mail'];
      request.fields['docname'] = "certificate1";
      print(request.fields);
      showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Uploading'),
              content: Lottie.asset('lib/assets/lottie/loading.json', height: 100, width: 100),
            );
          }
      );
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      Navigator.pop(context);
      SnackBar snackBar = SnackBar(
        content: Text(response.body),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("lib/assets/images/logow.png"),
                    width: 40,
                    height: 40,
                  ),
                  Spacer(),
                  Text('Admin Home',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Centauri')),
                ],
              )),
          const SizedBox(height: 100),
          Lottie.asset('lib/assets/lottie/admin.json', height: 125, width: 125),
          Text('Hello, ${widget.data['givenName']}',
              style: const TextStyle(fontSize: 15, fontFamily: 'Exo')),
          const SizedBox(height: 70),
          Mybox(
            color: Theme.of(context).colorScheme.primary,
            height:60,
            child:const Text('Enter email of the beneficiary of this certificate:',
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
            color: (isUploaded && emailController.text!='') ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withOpacity(0.3),
            onPressed: () => (isUploaded && emailController.text!='') ?
                handleUpload("https://siangkriti.eu.pythonanywhere.com/add") : null,
            text: 'Issue',
            icon: Icons.file_download_done_outlined,
          ),
        ],
      )),
    ));
  }
}
