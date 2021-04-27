import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pemesanancoffe/bloc/aut_service.dart';
import 'package:pemesanancoffe/model/form_tambah%20_dana_modeling.dart';
import 'package:pemesanancoffe/model/form_tambah%20_dana_vitual_bank.dart';

import 'package:pemesanancoffe/model/item_keranjang_modeling.dart';
import 'package:pemesanancoffe/model/item_makanan_modeling.dart';
import 'package:pemesanancoffe/model/item_minuman_modeling.dart';
import 'package:pemesanancoffe/model/keranjang.dart';

import 'package:pemesanancoffe/model/model_edit_dana_bank_modeling.dart';
import 'package:pemesanancoffe/model/model_edit_dana_virtual_bank.dart';

import 'package:pemesanancoffe/style/conts_color.dart';
import 'package:pemesanancoffe/style/text_style.dart';

int hargaTotal = 0;
int saldoTotal;
int saldoBank;
var kjgBox = Hive.box("keranjang");
var kjgOpenBox = Hive.openBox("keranjang");
Keranjang kjg;

class Menu extends StatefulWidget {
  String coffe;
  String id;
  String meja = '';
  FirebaseUser firebaseUser;
  Menu(
      {@required this.meja,
      @required this.firebaseUser,
      @required this.coffe,
      @required this.id});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with TickerProviderStateMixin {
  Keranjang dataKeranjang;
  String userIdBank = "";
  String userIdSaldo = "";

  String saldo = "";
  var ref;
  var refBank;

  TabController controller;

  String dataScan = "";
  String getScan = "";
  Future scanBarcode() async {
    getScan = await FlutterBarcodeScanner.scanBarcode(
        "#009922", "CENCEL", true, ScanMode.QR);
    if (getScan.contains(RegExp('[A-Z]')) ||
        getScan.contains(RegExp('[a-z]'))) {
      setState(() {
        dataScan = '-1';
      });
    } else {
      setState(() {
        dataScan = getScan;
      });
    }
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController _cariMakananMinumanController =
      TextEditingController(text: "");
  @override
  void initState() {
    _cariMakananMinumanController.addListener(_listenerController);
    scanBarcode().whenComplete(() {
      if (getScan.contains(RegExp('[A-Z]')) ||
          getScan.contains(RegExp('[a-z]')) ||
          getScan == '-1') {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  child: Container(
                    height: 150,
                    width: 100,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, right: 15, bottom: 20),
                          child: Text(
                            "Mohon Scan QR Code Meja Anda ! ",
                            style: textStyleSize12Black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Menu(
                                              id: "UC00" + widget.id,
                                              coffe: widget.coffe,
                                              firebaseUser: widget.firebaseUser,
                                              meja: dataScan,
                                            )));
                              },
                              elevation: 0.0,
                              color: colorAmber,
                              child: Text(
                                "Scan",
                                style: textStyleSize15,
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                exit(0);
                              },
                              elevation: 0.0,
                              color: Colors.red,
                              child: Text(
                                "Cencel",
                                style: textStyleSize15,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
        if (getScan.contains(RegExp('[0-100]'))) {
          print("DATA SCAn" + this.dataScan);
        }
      }
    });
    controller = TabController(length: 2, vsync: this);

    print(hargaTotal);
    super.initState();
  }

  String makananMinuman = "";
  _listenerController() {
    print(makananMinuman);
    setState(() {
      makananMinuman = _cariMakananMinumanController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemKeranjang(
                        id: widget.id.toString(),
                        coffe: widget.coffe,
                        uid: widget.firebaseUser.uid,
                        hargaTotal: hargaTotal,
                        meja: "Meja" + dataScan,
                        user: widget.firebaseUser.displayName,
                      )));
        },
        backgroundColor: colorAmber,
        child: Stack(
          children: [
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              top: 10,
              child: Icon(
                Icons.shopping_cart_outlined,
                color: colorWhite,
                size: 20,
              ),
            ),
            FutureBuilder(
                future: Hive.openBox("keranjang"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error),
                      );
                    } else {
                      var kjgBox = Hive.box("keranjang");
                      return kjgBox.length == 0
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Text(""),
                            )
                          : Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                child: Center(
                                  child: Text(
                                    kjgBox.length.toString(),
                                    style: textStyleWhite,
                                  ),
                                ),
                              ),
                            );
                    }
                  } else {
                    return Center(
                      child: Container(),
                    );
                  }
                })
          ],
        ),
      ),
      backgroundColor: colorAmber,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5),
              margin: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 70,
              ),
              height: 40,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   widget.firebaseUser.displayName == null
                      //       ? ""
                      //       : widget.firebaseUser.displayName,
                      //   style: textStyleSize15Bold,
                      // ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: colorWhite,
                        ),
                        child: Text(
                          dataScan == '-1' ? "" : "Meja " + dataScan,
                          style: textStyleSize12,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: colorWhite,
                    ),
                    onPressed: () async {
                      await AuthService.signOut();
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 200,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: colorAmber2,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Saldo",
                              style: textStyleWhiteBold,
                            ),
                            StreamBuilder(
                              stream: Firestore.instance
                                  .collection('saldo_user')
                                  .where("type", isEqualTo: "Saldo")
                                  .where('uid',
                                      isEqualTo:
                                          widget.firebaseUser.uid + "SALDO")
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return SizedBox();
                                } else {
                                  for (var i = 0;
                                      i < snapshot.data.documents.length;
                                      i++) {
                                    ref = snapshot.data.documents[i].reference;
                                    saldo =
                                        snapshot.data.documents[i]['jum_saldo'];
                                    saldoTotal = int.parse(snapshot
                                        .data.documents[i]['jum_saldo']);
                                    String verifikasi = snapshot
                                        .data.documents[i]['verifikasi'];
                                    String id =
                                        snapshot.data.documents[i]['id'];
                                    userIdSaldo =
                                        snapshot.data.documents[i]['uid'];
                                    if (snapshot.hasData) {
                                      return verifikasi == ""
                                          ? Text(
                                              " [ID Pembayaran : " + id + "]",
                                              style: textStyleWhite11,
                                            )
                                          : Text.rich(TextSpan(children: [
                                              TextSpan(
                                                  text: " Rp. ",
                                                  style: textStyleWhite),
                                              TextSpan(
                                                  text:
                                                      snapshot.data.documents[i]
                                                          ['jum_saldo'],
                                                  style: textStyleWhiteBold),
                                            ]));
                                    } else {
                                      return Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: "Rp. ",
                                            style: textStyleWhite),
                                        TextSpan(
                                            text: "00.0 ",
                                            style: textStyleWhiteBold),
                                      ]));
                                    }
                                  }
                                  return SizedBox();
                                }
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.add_outlined,
                              color: colorWhite,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => widget
                                                      .firebaseUser.uid +
                                                  "SALDO" ==
                                              userIdSaldo
                                          ? userIdSaldo == null ||
                                                  userIdSaldo.isEmpty ||
                                                  userIdSaldo == ""
                                              ? FormSaldo(
                                                  id: "UC00" +
                                                      widget.id.toString(),
                                                  typePembayaran: "Saldo",
                                                  uid: widget.firebaseUser.uid +
                                                      "SALDO",
                                                  user: widget
                                                      .firebaseUser.displayName,
                                                )
                                              : FormEditSaldo(
                                                  type: "Saldo",
                                                  saldo: saldo,
                                                  id: "UC00" +
                                                      widget.id.toString(),
                                                  ref: ref,
                                                  uid: widget.firebaseUser.uid +
                                                      "SALDO",
                                                  user: widget
                                                      .firebaseUser.displayName,
                                                )
                                          : FormSaldo(
                                              id: "UC00" + widget.id.toString(),
                                              typePembayaran: "Saldo",
                                              uid: widget.firebaseUser.uid +
                                                  "SALDO",
                                              user: widget
                                                  .firebaseUser.displayName,
                                            )));
                            })
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: colorAmber2,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Virtual Bank",
                              style: textStyleWhiteBold,
                            ),
                            StreamBuilder(
                              stream: Firestore.instance
                                  .collection('virtualBank')
                                  .where("type", isEqualTo: "Virtual Bank")
                                  .where('uid',
                                      isEqualTo:
                                          widget.firebaseUser.uid + "BANK")
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return SizedBox();
                                } else {
                                  for (var i = 0;
                                      i < snapshot.data.documents.length;
                                      i++) {
                                    refBank =
                                        snapshot.data.documents[i].reference;
                                    saldo =
                                        snapshot.data.documents[i]['jum_saldo'];
                                    saldoBank = int.parse(snapshot
                                        .data.documents[i]['jum_saldo']);
                                    String verifikasi = snapshot
                                        .data.documents[i]['verifikasi'];
                                    String id =
                                        snapshot.data.documents[i]['id'];
                                    userIdBank =
                                        snapshot.data.documents[i]['uid'];
                                    if (snapshot.hasData) {
                                      return verifikasi == ""
                                          ? Text(
                                              " [ID Pembayaran : " + id + "]",
                                              style: textStyleWhite11,
                                            )
                                          : Text.rich(TextSpan(children: [
                                              TextSpan(
                                                  text: " Rp. ",
                                                  style: textStyleWhite),
                                              TextSpan(
                                                  text:
                                                      snapshot.data.documents[i]
                                                          ['jum_saldo'],
                                                  style: textStyleWhiteBold),
                                            ]));
                                    } else {
                                      return Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: "Rp. ",
                                            style: textStyleWhite),
                                        TextSpan(
                                            text: "00.0 ",
                                            style: textStyleWhiteBold),
                                      ]));
                                    }
                                  }
                                  return SizedBox();
                                }
                              },
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.add_outlined,
                              color: colorWhite,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => widget
                                                      .firebaseUser.uid +
                                                  "BANK" ==
                                              userIdBank
                                          ? userIdBank == null ||
                                                  userIdBank.isEmpty ||
                                                  userIdBank == ""
                                              ? FormSaldoBank(
                                                  id: "UC00" +
                                                      widget.id.toString(),
                                                  typePembayaran:
                                                      "Virtual Bank",
                                                  uid: widget.firebaseUser.uid +
                                                      "BANK",
                                                  user: widget
                                                      .firebaseUser.displayName,
                                                )
                                              : FormEditSaldoBank(
                                                  type: "Virtual Bank",
                                                  saldo: saldo,
                                                  id: "UC00" +
                                                      widget.id.toString(),
                                                  ref: refBank,
                                                  uid: widget.firebaseUser.uid +
                                                      "BANK",
                                                  user: widget
                                                      .firebaseUser.displayName,
                                                )
                                          : FormSaldoBank(
                                              id: "UC00" + widget.id.toString(),
                                              typePembayaran: "Virtual Bank",
                                              uid: widget.firebaseUser.uid +
                                                  "BANK",
                                              user: widget
                                                  .firebaseUser.displayName,
                                            )));
                            })
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: TextFormField(
                        controller: _cariMakananMinumanController,
                        textInputAction: TextInputAction.search,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: colorWhite,
                        style: textStyleWhite,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 15, right: 15, top: 15),
                          hintText: "Cari Makanan/Minuman",
                          hintStyle: textStyleWhite11,
                          suffixIcon: Icon(
                            Icons.search,
                            color: colorWhite,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorWhite)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorWhite)),
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TabBar(
                        controller: controller,
                        labelColor: colorAmber2,
                        indicatorColor: colorAmber2,
                        indicatorPadding: EdgeInsets.only(right: 40, left: 40),
                        tabs: [
                          Tab(
                            text: "Makanan",
                          ),
                          Tab(
                            text: "Minuman",
                          ),
                        ]),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 15),
                        child: TabBarView(controller: controller, children: [
                          Container(
                            height: 500,
                            child: FutureBuilder(
                                future: kjgOpenBox,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(snapshot.error),
                                      );
                                    } else {
                                      for (var i = 0; i < kjgBox.length; i++) {
                                        dataKeranjang = kjgBox.getAt(i);
                                        kjgBox.values;
                                        kjg = kjgBox.getAt(i);
                                      }
                                      return WatchBoxBuilder(
                                        box: kjgBox,
                                        builder: (context, keranjangs) =>
                                            StreamBuilder(
                                                stream: Firestore.instance
                                                    .collection("produks")
                                                    .where("coffe",
                                                        isEqualTo: widget.coffe)
                                                    .where("nama",
                                                        isGreaterThanOrEqualTo:
                                                            makananMinuman)
                                                    .where("jenis",
                                                        isEqualTo: "Makanan")
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                        snapshot) {
                                                  if (!snapshot.hasData)
                                                    return SizedBox();
                                                  else
                                                    return GridView.builder(
                                                        itemCount: snapshot.data
                                                            .documents.length,
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10,
                                                                left: 10),
                                                        gridDelegate:
                                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent:
                                                                    300,
                                                                childAspectRatio:
                                                                    2 / 2,
                                                                crossAxisSpacing:
                                                                    10,
                                                                mainAxisSpacing:
                                                                    10),
                                                        itemBuilder:
                                                            (context, index) {
                                                          String nama = snapshot
                                                                  .data
                                                                  .documents[
                                                              index]['nama'];
                                                          String photo = snapshot
                                                                  .data
                                                                  .documents[
                                                              index]['photo'];
                                                          String harga = snapshot
                                                                  .data
                                                                  .documents[
                                                              index]['harga'];
                                                          return InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                hargaTotal = kjgBox
                                                                            .length ==
                                                                        0
                                                                    ? hargaTotal +
                                                                        int.parse(
                                                                            harga)
                                                                    : kjg.totalHarga +
                                                                        int.parse(
                                                                            harga);

                                                                kjgBox.add(
                                                                    Keranjang(
                                                                        photo,
                                                                        harga,
                                                                        index,
                                                                        nama,
                                                                        1,
                                                                        hargaTotal));

                                                                kjgBox.length;
                                                                print(
                                                                    hargaTotal);
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    useRootNavigator:
                                                                        false,
                                                                    barrierDismissible:
                                                                        false,
                                                                    builder:
                                                                        (context) =>
                                                                            Dialog(
                                                                              elevation: 0.0,
                                                                              backgroundColor: Colors.transparent,
                                                                              child: Container(
                                                                                height: 100,
                                                                                width: 0,
                                                                                decoration: BoxDecoration(color: Colors.transparent, image: DecorationImage(image: AssetImage("assets/img/done.gif"))),
                                                                              ),
                                                                            ));
                                                              });
                                                              Timer(
                                                                  Duration(
                                                                      seconds:
                                                                          4),
                                                                  route);
                                                            },
                                                            child: ItemMakanan(
                                                              foto: photo,
                                                              harga: harga,
                                                              nama: nama,
                                                            ),
                                                          );
                                                        });
                                                }),
                                      );
                                    }
                                  } else {
                                    return Center(child: Container());
                                  }
                                }),
                          ),
                          Container(
                            height: 500,
                            child: FutureBuilder(
                                future: Hive.openBox("keranjang"),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(snapshot.error),
                                      );
                                    } else {
                                      var kjgBox = Hive.box("keranjang");

                                      return WatchBoxBuilder(
                                        box: kjgBox,
                                        builder: (context, keranjangs) =>
                                            StreamBuilder(
                                                stream: Firestore.instance
                                                    .collection("produks")
                                                    .where("coffe",
                                                        isEqualTo: widget.coffe)
                                                    .where("nama",
                                                        isGreaterThanOrEqualTo:
                                                            makananMinuman)
                                                    .where("jenis",
                                                        isEqualTo: "Minuman")
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                        snapshot) {
                                                  if (!snapshot.hasData)
                                                    return SizedBox();
                                                  else
                                                    return GridView.builder(
                                                        physics:
                                                            ScrollPhysics(),
                                                        itemCount: snapshot.data
                                                            .documents.length,
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10,
                                                                left: 10),
                                                        gridDelegate:
                                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent:
                                                                    300,
                                                                childAspectRatio:
                                                                    2 / 2,
                                                                crossAxisSpacing:
                                                                    10,
                                                                mainAxisSpacing:
                                                                    10),
                                                        itemBuilder:
                                                            (context, index) {
                                                          String nama = snapshot
                                                                  .data
                                                                  .documents[
                                                              index]['nama'];
                                                          String photo = snapshot
                                                                  .data
                                                                  .documents[
                                                              index]['photo'];
                                                          String harga = snapshot
                                                                  .data
                                                                  .documents[
                                                              index]['harga'];
                                                          return InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                kjgBox.add(Keranjang(
                                                                    photo,
                                                                    harga,
                                                                    index,
                                                                    nama,
                                                                    1,
                                                                    hargaTotal +
                                                                        int.parse(
                                                                            harga)));

                                                                kjgBox.length;
                                                                hargaTotal =
                                                                    hargaTotal +
                                                                        int.parse(
                                                                            harga);
                                                                print(
                                                                    hargaTotal);
                                                              });
                                                            },
                                                            child: ItemMinuman(
                                                              foto: photo,
                                                              harga: harga,
                                                              nama: nama,
                                                            ),
                                                          );
                                                        });
                                                }),
                                      );
                                    }
                                  } else {
                                    return Center(child: Container());
                                  }
                                }),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  route() {
    Navigator.pop(context);
  }
}
