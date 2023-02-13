import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'downloadshow.dart';
import 'downloadstore.dart';

void main() {
  //Get.put(AlbumProvider());
  //Get.put(AlbumController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'download',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: "/downloadstore", page: () => Downloadstore()),
        GetPage(name: "/download", page: () => DownloadFile())
      ],
      initialRoute: "/downloadstore",
    );
  }
}
