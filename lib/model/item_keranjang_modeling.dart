import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pemesanancoffe/layout/menu_page.dart';
import 'package:pemesanancoffe/model/keranjang.dart';
import 'package:pemesanancoffe/model/pembayaran_modeling.dart';
import 'package:pemesanancoffe/style/conts_color.dart';
import 'package:pemesanancoffe/style/text_style.dart';

var keranjangBox = Hive.box("keranjang");
var keranjangOpenBox = Hive.openBox("keranjang");
Keranjang keranjang;

class ItemKeranjang extends StatefulWidget {
  String coffe;
  int hargaTotal = 0;
  String meja;
  String id;
  String user, uid;
  ItemKeranjang(
      {this.hargaTotal,
      @required this.id,
      @required this.coffe,
      @required this.meja,
      @required this.user,
      @required this.uid});
  @override
  _ItemKeranjangState createState() => _ItemKeranjangState();
}

class _ItemKeranjangState extends State<ItemKeranjang> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int jumItem = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: colorAmber,
        title: Text(
          "Keranjang Belanja",
          style: textStyleSize15,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 500,
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
                                        borderRadius: BorderRadius.circular(5),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 120,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      keranjang.nama,
                                                      style:
                                                          textStyleSize12Black,
                                                    ),
                                                    Text(
                                                      "Rp. " + keranjang.harga,
                                                      style:
                                                          textStyleSize10Black,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (widget.hargaTotal ==
                                                            0) {
                                                          setState(() {
                                                            hargaTotal =
                                                                keranjang
                                                                    .totalHarga;
                                                            widget.hargaTotal =
                                                                keranjang
                                                                    .totalHarga;
                                                            jumItem =
                                                                keranjang.jum;
                                                          });
                                                        } else {
                                                          widget
                                                              .hargaTotal = widget
                                                                  .hargaTotal -
                                                              (int.parse(keranjang
                                                                      .harga) *
                                                                  keranjang
                                                                      .jum);
                                                          keranjangBox
                                                              .deleteAt(index);
                                                          hargaTotal =
                                                              widget.hargaTotal;

                                                          print(widget
                                                              .hargaTotal);
                                                        }
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (keranjang
                                                              .jum.isNegative) {
                                                            setState(() {
                                                              keranjang.jum = 0;
                                                              hargaTotal = 0;
                                                              widget.hargaTotal =
                                                                  0;
                                                              jumItem =
                                                                  keranjang.jum;
                                                            });
                                                          }
                                                          if (keranjang.jum ==
                                                              0) {
                                                            Scaffold.of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  "Tambahkan jumlah makanan/minuman anda"),
                                                            ));
                                                          } else {
                                                            setState(() {
                                                              jumItem =
                                                                  keranjang.jum;
                                                              keranjangBox.putAt(
                                                                  index,
                                                                  Keranjang(
                                                                      keranjang
                                                                          .foto,
                                                                      keranjang
                                                                          .harga,
                                                                      keranjang
                                                                          .id,
                                                                      keranjang
                                                                          .nama,
                                                                      keranjang
                                                                              .jum -
                                                                          1,
                                                                      widget
                                                                          .hargaTotal));
                                                              widget
                                                                  .hargaTotal = widget
                                                                      .hargaTotal -
                                                                  int.parse(
                                                                      keranjang
                                                                          .harga);
                                                              hargaTotal = widget
                                                                  .hargaTotal;
                                                              print("luar " +
                                                                  hargaTotal
                                                                      .toString());

                                                              print(widget
                                                                  .hargaTotal);
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          child: Center(
                                                              child: Container(
                                                            height: 2,
                                                            width: 15,
                                                            color: Colors.black,
                                                          )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                right: 15),
                                                        child: Text(keranjang
                                                            .jum
                                                            .toString()),
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              keranjangBox.putAt(
                                                                  index,
                                                                  Keranjang(
                                                                      keranjang
                                                                          .foto,
                                                                      keranjang
                                                                          .harga,
                                                                      keranjang
                                                                          .id,
                                                                      keranjang
                                                                          .nama,
                                                                      keranjang
                                                                              .jum +
                                                                          1,
                                                                      widget
                                                                          .hargaTotal));
                                                              widget
                                                                  .hargaTotal = widget
                                                                      .hargaTotal +
                                                                  (int.parse(
                                                                      keranjang
                                                                          .harga));
                                                              hargaTotal = widget
                                                                  .hargaTotal;
                                                              print("luar " +
                                                                  hargaTotal
                                                                      .toString());
                                                              print(widget
                                                                  .hargaTotal);
                                                            });
                                                          },
                                                          child:
                                                              Icon(Icons.add)),
                                                    ],
                                                  )
                                                ],
                                              ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                width: double.infinity,
                // margin: EdgeInsets.only(left: 15, right: 15),
                child: RaisedButton(
                  color: colorAmber,
                  onPressed: () {
                    if (keranjangBox.length <= 0) {
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        keranjangBox.length;
                        print(keranjangBox.length);
                      });

                      if (keranjangBox.length == 0) {
                        setState(() {
                          keranjang.totalHarga = 0;
                        });
                      }
                      if (widget.hargaTotal == 0) {
                        widget.hargaTotal = keranjang.totalHarga;
                      }
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                  child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 200,
                                width: 80,
                                child: Column(
                                  children: [
                                    Text(
                                      "Total",
                                      style: textStyleSize20Amber,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Rp. " + widget.hargaTotal.toString(),
                                      style: textStyleSize20Amber,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    RaisedButton(
                                      color: colorAmber,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Pembayaran(
                                                      id: widget.id,
                                                      coffe: widget.coffe,
                                                      uid: widget.uid,
                                                      totalHarga:
                                                          widget.hargaTotal,
                                                      meja: widget.meja,
                                                      user: widget.user,
                                                    )));
                                      },
                                      child: Text(
                                        "Pesan Sekarang",
                                        style: textStyleSize15,
                                      ),
                                    )
                                  ],
                                ),
                              )));
                    }
                  },
                  child: keranjangBox.length == 0
                      ? Text(
                          "Kembali untuk pilih menu",
                          style: textStyleSize15,
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pesan Sekarang",
                              style: textStyleSize15,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: colorWhite,
                            )
                          ],
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
