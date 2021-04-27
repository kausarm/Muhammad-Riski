import 'package:hive/hive.dart';
part 'keranjang.g.dart';

@HiveType(typeId: 0)
class Keranjang {
  @HiveField(0)
  String foto;
  @HiveField(1)
  int id;
  @HiveField(2)
  String nama;
  @HiveField(3)
  String harga;
  @HiveField(4)
  int jum;
  @HiveField(5)
  int totalHarga = 0;
  Keranjang(
      this.foto, this.harga, this.id, this.nama, this.jum, this.totalHarga);
}
