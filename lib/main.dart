import 'package:flutter/material.dart';
import 'package:pemesanancoffe/bloc/aut_service.dart';

import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:pemesanancoffe/layout/menu_coffe.dart';

import 'package:pemesanancoffe/model/keranjang.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(KeranjangAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService.firebaseUserStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MenuCoffe(),
      ),
    );
  }
}
