import 'package:flutter/material.dart';
import 'package:pemesanancoffe/bloc/aut_service.dart';
import 'package:pemesanancoffe/layout/register_page.dart';
import 'package:pemesanancoffe/style/conts_color.dart';
import 'package:pemesanancoffe/style/text_style.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController;
  TextEditingController passwordController;
  @override
  void initState() {
    usernameController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: colorAmber2,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 80, left: 15, right: 15),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Text(
              "Login",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 30,
                  color: colorWhite,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 150,
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
                  await AuthService.loginEmailPassword(
                      usernameController.text, passwordController.text);
                },
                color: colorAmber,
                child: Text(
                  "Login",
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                color: Colors.redAccent,
                child: Text(
                  "Daftar",
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
