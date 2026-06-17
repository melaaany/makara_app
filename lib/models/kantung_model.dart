import 'package:hive/hive.dart';

part 'kantung_model.g.dart';

@HiveType(typeId: 0)
class KantungModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nama;

  @HiveField(2)
  double saldo;

  @HiveField(3)
  final double alokasiAwal;

  @HiveField(4)
  final String jenisKategori; // 'HIDUP', 'NONGKRONG', 'KULIAH', 'GEMBOK'

  KantungModel({
    required this.id,
    required this.nama,
    required this.saldo,
    required this.alokasiAwal,
    required this.jenisKategori,
  });
}