import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SaldoTopUpBase {
  void topUp(String id, String type, var nama, var jumlah, var konfirmasi,
      String uid, String tmpSaldo, BuildContext context) {
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference =
          Firestore.instance.collection("saldo_user");
      reference.add({
        "nama_user": nama,
        "id": id,
        "jum_saldo": jumlah,
        "tambah_saldo": tmpSaldo,
        "uid": uid,
        "verifikasi": konfirmasi,
        "type": type
      });
    });
  }

  void topUpVirtualBank(String id, String type, var nama, var jumlah,
      var konfirmasi, String uid, String tmpSaldo, BuildContext context) {
    Firestore.instance.runTransaction((transaction) async {
      CollectionReference reference =
          Firestore.instance.collection("virtualBank");
      reference.add({
        "nama_user": nama,
        "id": id,
        "jum_saldo": jumlah,
        "tambah_saldo": tmpSaldo,
        "uid": uid,
        "verifikasi": konfirmasi,
        "type": type
      });
    });
  }

  void updateSaldoBank(String jumSaldo, String id, String type, var index,
      String nama, String uid, String konfirmasi, String tmpSaldo) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.get(index);
      await transaction.update(index, {
        "nama_user": nama,
        "id": id,
        "jum_saldo": jumSaldo,
        "tambah_saldo": tmpSaldo,
        "uid": uid,
        "verifikasi": konfirmasi,
        "type": type
      });
    });
  }

  void updateSaldo(String jumSaldo, String id, String type, var index,
      String nama, String uid, String konfirmasi, String tmpSaldo) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.get(index);
      await transaction.update(index, {
        "nama_user": nama,
        "id": id,
        "jum_saldo": jumSaldo,
        "tambah_saldo": tmpSaldo,
        "uid": uid,
        "verifikasi": konfirmasi,
        "type": type
      });
    });
  }
}
