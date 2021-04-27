import 'package:flutter/material.dart';
import 'package:pemesanancoffe/bloc/aut_service.dart';
import 'package:pemesanancoffe/layout/menu_page.dart';
import 'package:pemesanancoffe/layout/wrapper.dart';
import 'package:pemesanancoffe/style/conts_color.dart';
import 'package:pemesanancoffe/style/text_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController;

  TextEditingController usernameController;
  TextEditingController passwordController;
  @override
  void initState() {
    nameController = TextEditingController(text: "");
    usernameController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  _showSnackBar() {
    final snackBar = SnackBar(
      content: Text("Tunggu Sebentar..."),
      action: SnackBarAction(
          label: "close",
          onPressed: () {
            print("close");
          }),
    );
    _scaffoldState.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      resizeToAvoidBottomPadding: false,
      backgroundColor: colorAmber2,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 80, left: 15, right: 15),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Text(
              "Daftar",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 30,
                  color: colorWhite,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 120,
            ),
            textFormField("Name", nameController),
            SizedBox(
              height: 30,
            ),
            textFormField("Email", usernameController),
            SizedBox(
              height: 30,
            ),
            textFormField("Password", passwordController),
            Container(
              width: 200,
              height: 50,
              margin: EdgeInsets.only(top: 30),
              // ignore: deprecated_member_use
              child: RaisedButton(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () async {
                  _showSnackBar();
                  await AuthService.createUserWithEmailAndPassword(
                          nameController.text,
                          usernameController.text,
                          passwordController.text)
                      .whenComplete(() async {
                    AuthService.signOut().whenComplete(() {
                      AuthService.loginEmailPassword(
                          usernameController.text, passwordController.text);
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  });
                },
                color: colorAmber,
                child: Text(
                  "Daftar",
                  style: textStyleSize15Bold,
                ),
              ),
            ),
            Container(
              width: 200,
              height: 50,
              margin: EdgeInsets.only(top: 30),
              // ignore: deprecated_member_use
              child: RaisedButton(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.redAccent,
                child: Text(
                  "Back",
                  style: textStyleSize15Bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField textFormField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: label == "Password" ? true : false,
      cursorColor: colorWhite,
      style: textStyleSize15,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: textStyleSize15,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: colorWhite, style: BorderStyle.solid, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: colorWhite, style: BorderStyle.solid, width: 1)),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: colorWhite, style: BorderStyle.solid, width: 1))),
    );
  }
}
