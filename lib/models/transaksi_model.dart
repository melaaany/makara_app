import 'package:hive/hive.dart';

part 'transaksi_model.g.dart';

@HiveType(typeId: 1)
class TransaksiModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String kantungId;

  @HiveField(2)
  final String judul;

  @HiveField(3)
  final double nominal;

  @HiveField(4)
  final DateTime tanggal;

  @HiveField(5)
  final bool isPengeluaran; // true jika pengeluaran, false jika pemasukan

  TransaksiModel({
    required this.id,
    required this.kantungId,
    required this.judul,
    required this.nominal,
    required this.tanggal,
    required this.isPengeluaran,
  });
}