import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_three_app/Button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:web_three_app/main.dart';
import 'package:web_three_app/pdfViewer.dart';
import 'package:web_three_app/profileOverview.dart';
import 'box.dart';

class DownloadPage extends StatefulWidget {
  @override
  State<DownloadPage> createState() => _DownloadPage();
}

class _DownloadPage extends State<DownloadPage> {
  void openPdf(BuildContext context, File file, String url) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(
            file: file,
            url: url,
          ),
        ),
      );
  Future<File> loadPdfFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final file = File('/storage/emulated/0/Download/$filename.pdf');
    if(!(await file.exists())) await file.writeAsBytes(bytes, flush: true);
    if (kDebugMode) {
      print('$file');
    }
    return file;
  }

  @override
  Widget build(BuildContext context) {
    handleReload() async {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reloading'),
          content: Lottie.asset('lib/assets/lottie/loading.json', height: 100, width: 100),
        );
      });
      Response response;
      Dio dio = Dio();
      response = await dio.get("https://siangkriti.eu.pythonanywhere.com/getcerts?email='${data['mail']}'");
      urls = response.data["urls"];
      Navigator.pop(context);
      setState(() {});
    }
    handleDownload(url) async {
      showDialog(context: context, builder:
          (BuildContext context) {
        return AlertDialog(
          title: const Text('Downloading'),
          content: Lottie.asset('lib/assets/lottie/loading.json', height: 100, width: 100),
        );
      });
      final file = await loadPdfFromNetwork(url);
      Navigator.pop(context);
      openPdf(context, file, url);
    }

    return Scaffold(
        body:
        Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: context.isDarkMode
              ? const AssetImage("lib/assets/images/dark-background.png")
              : const AssetImage("lib/assets/images/light-background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
    child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("lib/assets/images/logow.png"),
                    width: 40,
                    height: 40,
                  ),
                  Spacer(),
                  Text('Download',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Centauri')),
                ],
              ),),
            const SizedBox(height: 70),
            ProfileOverview(image: Lottie.asset('lib/assets/lottie/downloadimage.json', width: 125, height: 125,)),
            const SizedBox(height: 150),
            Container(
              height:60,
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child:Row(
                children:[const Text('Here are all your certificates',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Exo',
                  )),
                const Spacer(),
                MyButton(text: "", icon: Icons.loop, color: Theme.of(context).colorScheme.primary, width: 100, onPressed: ()=>handleReload(),)],
            )),
            const SizedBox(height: 70),

            for(var x in urls)
              Column(
                children: [
                  MyButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () => handleDownload(x[0]),
                    text: 'Certificate from ${x[1].length > 10 ? x[1].substring(0, 10) + '...' : x[1]}',
                    icon: Icons.download,
                  ),
                  const SizedBox(height: 30),
                ],
              )



          ],
        )),
      ),
    ));
  }
}
