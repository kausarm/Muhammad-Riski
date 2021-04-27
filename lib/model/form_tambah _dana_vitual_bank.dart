import 'package:flutter/material.dart';
import 'package:pemesanancoffe/database/top_up_saldo_base.dart';
import 'package:pemesanancoffe/style/conts_color.dart';
import 'package:pemesanancoffe/style/text_style.dart';

class FormSaldoBank extends StatefulWidget {
  String user;
  String uid;
  String id;
  String typePembayaran;
  FormSaldoBank(
      {@required this.user,
      @required this.uid,
      @required this.id,
      @required this.typePembayaran});
  @override
  _FormSaldoBankState createState() => _FormSaldoBankState();
}

class _FormSaldoBankState extends State<FormSaldoBank> {
  TextEditingController jumSaldoControlle;
  @override
  void initState() {
    jumSaldoControlle = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorAmber,
        title: Text(
          "Saldo Virtual Bank",
          style: textStyleSize15,
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              field("Rp. (Jumlah Top-Up)"),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 50,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: colorAmber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    SaldoTopUpBase().topUpVirtualBank(
                        widget.id,
                        widget.typePembayaran,
                        widget.user,
                        jumSaldoControlle.text,
                        "",
                        widget.uid,
                        "",
                        context);
                    print(widget.typePembayaran);

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
                                      "Silahkan ke kasir untuk melakukan pembayaran",
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
                  },
                  child: Text(
                    "Tambah Saldo",
                    style: textStyleSize15,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        itemHarga("50000"),
                        itemHarga("100000"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        itemHarga("150000"),
                        itemHarga("200000"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField field(String label) {
    return TextFormField(
      controller: this.jumSaldoControlle,
      maxLines: label == "Deskripsi pengeluaran" ? 10 : 1,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorAmber,
            width: 1,
          ),
        ),
        hintStyle: textStyleSize10Black,
        hintText:
            label == "Deskripsi pengeluaran" ? "Deskripsi pengeluaran" : null,
        labelText: label == "Deskripsi pengeluaran" ? null : label,
        labelStyle: textStyleSize10Black,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorAmber,
            width: 1,
          ),
        ),
      ),
    );
  }

  Expanded itemHarga(String money) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            this.jumSaldoControlle.text = money;
          });
        },
        child: new Container(
          margin: EdgeInsets.only(right: 10),
          height: 100,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorWhite,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black12,
                  offset: new Offset(2, 2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ]),
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: "Rp. ",
              style: textStyleSize15Black,
            ),
            TextSpan(text: money, style: textStyleSize15Black)
          ])),
        ),
      ),
    );
  }
}
