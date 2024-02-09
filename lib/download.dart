import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    await file.writeAsBytes(bytes, flush: true);
    if (kDebugMode) {
      print('$file');
    }
    return file;
  }

  @override
  Widget build(BuildContext context) {
    handleDownload(url) async {
      final file = await loadPdfFromNetwork(url);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Download',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Centauri')),
            const SizedBox(height: 70),
            ProfileOverview(image: Lottie.asset('lib/assets/lottie/downloadimage.json', width: 125, height: 125,)),
            const SizedBox(height: 150),
            Mybox(
              color: Theme.of(context).colorScheme.primary,
              height:60,
              child:const Text('Here are all your certificates',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Exo',
                  )),
            ),
            const SizedBox(height: 70),

            for(var x in urls)
              Column(
                children: [
                  MyButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () => handleDownload(x[0]),
                    text: 'Certificate from ${x[1]}',
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
