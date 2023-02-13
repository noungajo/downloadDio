import 'dart:io';
import 'package:path_provider/path_provider.dart' as p;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Downloadstore extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "Download store";

  @override
  State<Downloadstore> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Downloadstore> {
  String _fileFullPath = "", progress = "";

  bool _isLoading = false;
  final urlPdf = "http://www.pdf995.com/samples/pdf.pdf";

  String fileName = "";
  Dio dio;
  @override
  void initState() {
    dio = Dio();
    super.initState();
  }

  Future<List<Directory>> _getExternalSTorage() {
    //pour la musique on met juste dans musique
    var chemin =
        p.getExternalStorageDirectories(type: p.StorageDirectory.documents);

    return chemin;
  }

  Future _downloadAndStoreFile(
      BuildContext context, String urlPath, String fileName) async {
    ProgressDialog pr;
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: "Downloading file ...");

    try {
      //=====Show dialog ======
      await pr.show();
      final dirList = await _getExternalSTorage();
      final path = dirList[0].path;
      final file = File('$path/$fileName');
      await dio.download(
        urlPath,
        file.path,
        /*   onReceiveProgress: (count, total) {
          setState(() {
            _isLoading = true;
            progress = ((count / total) * 100).toStringAsFixed(0) + "%";
            print(progress);
            // ===== update dialog ==============
            pr.update(message: "Please wait : $progress");
          });
        },*/
      );
      //==== hide dialog=======
      pr.hide();
      _fileFullPath = file.path;
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                _downloadAndStoreFile(context, urlPdf, "jonathan.pdf");
              },
              child: Text('Write to External STorage')),
          Text("Written : $_fileFullPath")
        ],
      )),
    );
  }
}
