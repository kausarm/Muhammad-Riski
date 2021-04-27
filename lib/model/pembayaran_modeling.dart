import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pemesanancoffe/database/pembayaran_base.dart';
import 'package:pemesanancoffe/database/top_up_saldo_base.dart';
import 'package:pemesanancoffe/layout/menu_page.dart';

import 'package:pemesanancoffe/model/virtual_akun_modeling.dart';
import 'package:pemesanancoffe/style/conts_color.dart';
import 'package:pemesanancoffe/style/text_style.dart';

import 'keranjang.dart';

enum SingingCharacter { saldo, virtual_account }
var keranjangBox = Hive.box("keranjang");
var keranjangOpenBox = Hive.openBox("keranjang");
Keranjang keranjang;
var ref;
var refbank;

class Pembayaran extends StatefulWidget {
  int totalHarga;
  String id;
  String user;
  String coffe;
  String meja;
  String uid;
  Pembayaran({
    @required this.id,
    @required this.coffe,
    @required this.totalHarga,
    @required this.meja,
    @required this.user,
    @required this.uid,
  });
  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  SingingCharacter _character = SingingCharacter.saldo;
  String saldo = '0';
  String saldobank = '0';
  var data = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAmber,
        title: Text(
          "Pembayaran",
          style: textStyleSize15,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: 270,
                child: FutureBuilder(
                  future: keranjangOpenBox,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error),
                        );
                      } else {
                        return WatchBoxBuilder(
                          box: keranjangBox,
                          builder: (context, keranjangs) => ListView.builder(
                            itemCount: keranjangBox.length,
                            itemBuilder: (context, index) {
                              keranjang = keranjangBox.getAt(index);
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, right: 15),
                                      decoration: BoxDecoration(
                                          color: colorWhite,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 15,
                                                offset: Offset(3, 3))
                                          ]),
                                      child: Container(
                                        height: 80,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          keranjang.foto),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 120,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        keranjang.nama,
                                                        style:
                                                            textStyleSize12Black,
                                                      ),
                                                      Text(
                                                        "Rp. " +
                                                            keranjang.harga,
                                                        style:
                                                            textStyleSize10Black,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(keranjang.jum.toString() +
                                                    " X"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: colorAmber,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                    child: Text(
                  "Total: Rp. " + widget.totalHarga.toString(),
                  style: textStyleSize15Bold,
                )),
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: colorAmber, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Metode Pembayaran",
                      style: textStyleSize15,
                    ),
                    ListTile(
                      title: const Text(
                        'Saldo',
                        style: textStyleSize15,
                      ),
                      leading: Radio(
                        activeColor: colorWhite,
                        value: SingingCharacter.saldo,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                            print(_character);
                          });
                        },
                      ),
                    ),
                    _character == SingingCharacter.saldo
                        ? Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection('saldo_user')
                                  .where("type", isEqualTo: "Saldo")
                                  .where("uid", isEqualTo: widget.uid + "SALDO")
                                  .where('verifikasi', isEqualTo: 'sukses')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  for (var i = 0;
                                      i < snapshot.data.documents.length;
                                      i++) {
                                    saldo =
                                        snapshot.data.documents[i]['jum_saldo'];
                                    ref = snapshot.data.documents[i].reference;

                                    if (snapshot.hasData) {
                                      return Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: hargaTotal > saldoTotal
                                                ? "Total Saldo Tidak Cukup"
                                                : "Total Saldo Rp. ",
                                            style: hargaTotal > int.parse(saldo)
                                                ? textStyleRed
                                                : textStyleWhite),
                                        TextSpan(
                                            text: hargaTotal > int.parse(saldo)
                                                ? ""
                                                : snapshot.data.documents[i]
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
                                }
                                return SizedBox();
                              },
                            ),
                          )
                        : SizedBox(),
                    ListTile(
                      title: const Text(
                        'Virtual Bank',
                        style: textStyleSize15,
                      ),
                      leading: Radio(
                        activeColor: colorWhite,
                        value: SingingCharacter.virtual_account,
                        groupValue: _character,
                        onChanged: (value) {
                          setState(() {
                            _character = value;
                            print(_character);
                          });
                        },
                      ),
                    ),
                    _character == SingingCharacter.virtual_account
                        ? Padding(
                            padding: const EdgeInsets.only(left: 35),
                            child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection('virtualBank')
                                  .where("type", isEqualTo: "Virtual Bank")
                                  .where("uid", isEqualTo: widget.uid + "BANK")
                                  .where('verifikasi', isEqualTo: 'sukses')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  for (var i = 0;
                                      i < snapshot.data.documents.length;
                                      i++) {
                                    saldobank =
                                        snapshot.data.documents[i]['jum_saldo'];
                                    refbank =
                                        snapshot.data.documents[i].reference;

                                    if (snapshot.hasData) {
                                      return Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: hargaTotal > saldoBank
                                                ? "Total Saldo Tidak Cukup"
                                                : "Total Saldo Rp. ",
                                            style: hargaTotal >
                                                    int.parse(saldobank)
                                                ? textStyleRed
                                                : textStyleWhite),
                                        TextSpan(
                                            text: hargaTotal >
                                                    int.parse(saldobank)
                                                ? ""
                                                : snapshot.data.documents[i]
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
                                }
                                return SizedBox();
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: RaisedButton(
                  onPressed: () async {
                    if (_character == SingingCharacter.virtual_account) {
                      validasiPemayaran(saldoBank, refbank, "BANK");
                    } else {
                      validasiPemayaran(saldoTotal, ref, "SALDO");
                    }
                  },
                  color: colorAmber,
                  child: Text(
                    "Selesai",
                    style: textStyleSize15,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  route() {
    Navigator.pop(context);
    Timer(Duration(seconds: 1), route2);
  }

  route2() {
    showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (context) => Dialog(
              elevation: 0.0,
              backgroundColor: colorWhite,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 200,
                width: 0,
                decoration: BoxDecoration(
                  color: colorWhite,
                ),
                child: Column(
                  children: [
                    Text(
                      "Terimakasih :)",
                      style: textStyleSize15Black,
                    ),
                    Text(
                      "Pesanan anda sedang di proses",
                      style: textStyleSize15Black,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      color: colorAmber,
                      elevation: 0.0,
                      onPressed: () {
                        setState(() {
                          for (var i = 0; i < keranjangBox.length; i++) {
                            keranjangBox.deleteAt(i);
                            print("panjang " + i.toString());
                            print("banyak tinggal" +
                                keranjangBox.length.toString());
                          }
                          keranjangBox.length;
                          if (keranjangBox.length == 1) {
                            keranjangBox.deleteAt(0);
                          }
                          if (keranjangBox.length == 0) {
                            setState(() {
                              hargaTotal = 0;
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          }
                        });
                      },
                      child: Text(
                        "Konfirmasi",
                        style: textStyleSize15,
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  void validasiPemayaran(int totalSaldo, var referen, String type) {
    if (hargaTotal > totalSaldo) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      showDialog(
          context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (context) => Dialog(
                elevation: 0.0,
                backgroundColor: colorWhite,
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 200,
                  width: 0,
                  decoration: BoxDecoration(
                    color: colorWhite,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Mohon maaf saldo todak cukup :(",
                        style: textStyleSize15Black,
                      ),
                      Text(
                        "Silahkan Top-Up Saldo terlebih dahulu",
                        textAlign: TextAlign.center,
                        style: textStyleSize15Black,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RaisedButton(
                        color: colorAmber,
                        elevation: 0.0,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "OK",
                          style: textStyleSize15,
                        ),
                      )
                    ],
                  ),
                ),
              ));
    } else {
      for (var i = 0; i < keranjangBox.length; i++) {
        keranjang = keranjangBox.getAt(i);
        data.add(keranjang.nama);

        if (data.length == keranjangBox.length) {
          PembayaranBase().pembelianBrg(data, widget.totalHarga, widget.user,
              widget.meja, widget.coffe, "Sudah Di Bayar", "", context);
          showDialog(
              context: context,
              useRootNavigator: false,
              barrierDismissible: false,
              builder: (context) => Dialog(
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    child: Container(
                      height: 100,
                      width: 0,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                              image: AssetImage("assets/img/done.gif"))),
                    ),
                  ));

          Timer(Duration(seconds: 4), route);
        }
      }
      int total = totalSaldo - widget.totalHarga;
      SaldoTopUpBase().updateSaldo(
          total.toString(),
          "UC00" + widget.id,
          _character == SingingCharacter.saldo ? "Saldo" : "Virtual Bank",
          referen,
          widget.user,
          type == "SALDO" ? widget.uid + "SALDO" : widget.uid + "BANK",
          "sukses",
          "");
    }
  }
}
