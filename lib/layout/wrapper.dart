import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pemesanancoffe/layout/login_page.dart';
import 'package:pemesanancoffe/layout/menu_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  String coffe;
  String randomNumber;
  Wrapper({@required this.coffe, @required this.randomNumber});

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    return (firebaseUser == null)
        ? Login()
        : Menu(
            id: widget.randomNumber.toString(),
            coffe: widget.coffe,
            firebaseUser: firebaseUser,
            meja: "Meja 1",
          );
  }
}
