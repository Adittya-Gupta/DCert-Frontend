
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_three_app/Button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:web_three_app/pdfViewer.dart';
import 'box.dart';

class DownloadPage extends StatefulWidget {

  @override
  State<DownloadPage> createState()  => _DownloadPage();

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
    final dir = await getApplicationDocumentsDirectory();
    print(dir);
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    if (kDebugMode) {
      print('$file');
    }
    return file;
  }
  @override
  Widget build(BuildContext context) {

    handleDownload () async{
      const url =
          "https://gateway.pinata.cloud/ipfs/QmYbxfn5pZyhw1hj7ffnmG5RaAGQtZ3fvqNRpCA6diBfpj";
      final file = await loadPdfFromNetwork(url);
      openPdf(context, file, url);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Download',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Centauri')),
            const SizedBox(height: 150),
            MyButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () => handleDownload(),
            ),
            const SizedBox(height: 70),
            const Text('Download your files here', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
