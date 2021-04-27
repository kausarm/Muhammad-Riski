import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PembayaranBase {
  void pembelianBrg(
      var nama,
      int total,
      String pembeli,
      String meja,
      String coffe,
      String pembayaran,
      String konfirmasi,
      BuildContext context) {
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference =
          Firestore.instance.collection("pembelian_brg");
      reference.add({
        "nama_barang": nama,
        "total": total,
        "user": pembeli,
        "meja": meja,
        "coffe": coffe,
        "pembayaran": pembayaran,
        "konfirmasi": konfirmasi
      });
    });
  }
}
