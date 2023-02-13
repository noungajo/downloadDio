import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart' as p;

//pour le souci de certificat. ne pas l'utiliser en production juste en dev
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// void main() {
//   runApp(DownloadFile());
// }

class DownloadFile extends StatefulWidget {
  @override
  State createState() {
    return _DownloadFileState();
  }
}

class _DownloadFileState extends State {
  var imageUrl =
      "https://www.itl.cat/pngfile/big/10-100326_desktop-wallpaper-hd-full-screen-free-download-full.jpg";
  bool downloading = true;
  String downloadingStr = "No data";
  String savePath = "";
  double pourcentage = 0.0;
  Future<List<Directory>> _getExternalSTorage() {
    //pour la musique on met juste dans musique
    var chemin =
        p.getExternalStorageDirectories(type: p.StorageDirectory.documents);

    return chemin;
  }

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future downloadFile() async {
    try {
      Dio dio = Dio();
      final dirList = await _getExternalSTorage();
      final path = dirList[0].path;
      String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
      final file = File('$path/$fileName');

      savePath = file.path;
      await dio.download(imageUrl, file.path, onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          // download = (rec / total) * 100;
          pourcentage = rec / total;
          downloadingStr = "Downloading Image : $rec";
        });
      });
      setState(() {
        downloading = false;
        downloadingStr = "Completed";
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir = await p.getApplicationDocumentsDirectory();

    path = '${dir.path}/$uniqueFileName';

    return path;
  }

  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = MyHttpOverrides();
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.pink),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Download File"),
          backgroundColor: Colors.pink,
        ),
        body: Center(
          child: downloading
              ? Container(
                  height: 250,
                  width: 250,
                  child: Card(
                    color: Colors.pink,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                            value:
                                pourcentage, //pour que la porgression soit guidée
                            backgroundColor: Colors
                                .white, //pour distinguer la partie en cours et terminée
                            color: Colors.red //coleur de la progression
                            ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          downloadingStr,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 250,
                  width: 250,
                  child: Center(
                    child: Image.file(
                      File(savePath),
                      height: 200,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
