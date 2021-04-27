import 'package:flutter/material.dart';
import 'package:pemesanancoffe/style/conts_color.dart';
import 'package:pemesanancoffe/style/text_style.dart';

class ItemMakanan extends StatelessWidget {
  String foto, nama, harga;
  ItemMakanan({this.foto, this.harga, this.nama});
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: colorAmber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              image: DecorationImage(
                  image: NetworkImage(this.foto), fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 115,
                      child: Text(
                        this.nama,
                        style: textStyleSize10Black,
                      ),
                    ),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: "Rp. ", style: textStyleSize10Black),
                      TextSpan(text: this.harga, style: textStyleSize10Black)
                    ]))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.add,
                    color: colorAmber,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
