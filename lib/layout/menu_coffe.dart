import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pemesanancoffe/layout/wrapper.dart';
import 'package:pemesanancoffe/style/conts_color.dart';
import 'package:pemesanancoffe/style/text_style.dart';

class MenuCoffe extends StatelessWidget {
  Random random = new Random();
  @override
  Widget build(BuildContext context) {
    int randomNumber = random.nextInt(1000);

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 15, right: 15),
          height: 300,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper(
                                        randomNumber: randomNumber.toString(),
                                        coffe: "Coffe 1",
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5, bottom: 5),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: colorAmber,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Coffe 1",
                                style: textStyleWhite30,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.qr_code_scanner_sharp,
                                  color: colorWhite,
                                  size: 35,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper(
                                        coffe: "Coffe 2",
                                        randomNumber: randomNumber.toString(),
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 5, bottom: 5),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: colorAmber,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Coffe 2",
                                style: textStyleWhite30,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Icon(
                                  Icons.qr_code_scanner_sharp,
                                  color: colorWhite,
                                  size: 35,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Wrapper(
                                  coffe: "Coffe 3",
                                  randomNumber: randomNumber.toString(),
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: colorAmber,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Coffe 3",
                          style: textStyleWhite30,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.qr_code_scanner_sharp,
                            color: colorWhite,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
