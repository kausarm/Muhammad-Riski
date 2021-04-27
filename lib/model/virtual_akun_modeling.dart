import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pemesanancoffe/style/conts_color.dart';
import 'package:pemesanancoffe/style/text_style.dart';

class VirtualAkun extends StatefulWidget {
  @override
  _VirtualAkunState createState() => _VirtualAkunState();
}

class _VirtualAkunState extends State<VirtualAkun> {
  File img;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      img = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAmber,
      ),
      body: Column(
        children: [
          Container(
            height: 230,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(left: 20, right: 20, top: 70),
            decoration: BoxDecoration(
                color: colorAmber, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Text(
                  "Pembayaran Virtual",
                  style: textStyleWhiteBold,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'BRI: 3924-01-008821-53-2',
                  style: textStyleWhite20,
                ),
                SizedBox(
                  height: img == null ? 50 : 20,
                ),
                img == null
                    ? IconButton(
                        color: colorWhite,
                        icon: Icon(
                          Icons.camera_alt,
                          color: colorWhite,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      )
                    : InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                          child: Image.file(
                            img,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
