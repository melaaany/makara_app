import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/kantung_model.dart';
import '../models/transaksi_model.dart';

class KeuanganProvider with ChangeNotifier {
  late Box<KantungModel> _kantungBox;
  late Box<TransaksiModel> _transaksiBox;

  List<KantungModel> _daftarKantung = [];
  List<TransaksiModel> _daftarTransaksi = [];

  String _statusPeringatanNongkrong = "Aman";

  List<KantungModel> get daftarKantung => _daftarKantung;
  List<TransaksiModel> get daftarTransaksi => _daftarTransaksi;
  String get statusPeringatanNongkrong => _statusPeringatanNongkrong;

  double get totalSaldoKeseluruhan {
    return _daftarKantung.fold(0.0, (total, kantung) => total + kantung.saldo);
  }

  // Inisialisasi Database dan Data Default Kantung Mahasiswa
  Future<void> inisialisasiDatabase() async {
    _kantungBox = Hive.box<KantungModel>('kantungBox');
    _transaksiBox = Hive.box<TransaksiModel>('transaksiBox');

    _daftarKantung = _kantungBox.values.toList();
    _daftarTransaksi = _transaksiBox.values.toList();

    // Jika database kosong, buat default 4 Kantung Saku Makara utama
    if (_daftarKantung.isEmpty) {
      final kantungDefault = [
        KantungModel(id: '1', nama: 'Kantung Hidup (Kos & Makan)', saldo: 1200000, alokasiAwal: 1200000, jenisKategori: 'HIDUP'),
        KantungModel(id: '2', nama: 'Kantung Nongkrong (Lifestyle)', saldo: 500000, alokasiAwal: 500000, jenisKategori: 'NONGKRONG'),
        KantungModel(id: '3', nama: 'Kantung Tugas & Kuliah', saldo: 300000, alokasiAwal: 300000, jenisKategori: 'KULIAH'),
        KantungModel(id: '4', nama: 'Kantung Gembok (Tabungan)', saldo: 500000, alokasiAwal: 500000, jenisKategori: 'GEMBOK'),
      ];

      for (var kantung in kantungDefault) {
        await _kantungBox.put(kantung.id, kantung);
      }
      _daftarKantung = _kantungBox.values.toList();
    }
    evaluasiBatasNongkrong();
    notifyListeners();
  }

  // Operasi Catat Transaksi Baru
  Future<void> tambahTransaksi(TransaksiModel transaksi) async {
    await _transaksiBox.put(transaksi.id, transaksi);
    _daftarTransaksi.add(transaksi);

    // Cari kantung tujuan untuk memperbarui saldo internal
    final kantung = _daftarKantung.firstWhere((k) => k.id == transaksi.kantungId);
    if (transaksi.isPengeluaran) {
      kantung.saldo -= transaksi.nominal;
    } else {
      kantung.saldo += transaksi.nominal;
    }

    await _kantungBox.put(kantung.id, kantung);
    evaluasiBatasNongkrong();
    notifyListeners();
  }

  // Logika Evaluasi "Rem Jajan" - Memicu Pengingat jika Budget Sisa < 20%
  void evaluasiBatasNongkrong() {
    final kantungNongkrong = _daftarKantung.firstWhere(
          (k) => k.jenisKategori == 'NONGKRONG',
      orElse: () => KantungModel(id: '', nama: '', saldo: 1, alokasiAwal: 1, jenisKategori: ''),
    );

    if (kantungNongkrong.id.isNotEmpty) {
      double rasioSisa = kantungNongkrong.saldo / kantungNongkrong.alokasiAwal;
      if (rasioSisa <= 0.2 && rasioSisa > 0) {
        _statusPeringatanNongkrong = "REM JAJAN! Saldo Nongkrong Tipis Sisa < 20%";
      } else if (rasioSisa <= 0) {
        _statusPeringatanNongkrong = "KRITIS! Anggaran Jajan Habis";
      } else {
        _statusPeringatanNongkrong = "Aman";
      }
    }
  }

  // Logika Fitur Utama: Split Bill (Kalkulator Patungan Mahasiswa)
  Map<String, double> hitungMatematikaSplitBill({
    required double totalTagihan,
    required int jumlahOrang,
    required double persenPajakServis,
  }) {
    double nominalPajak = totalTagihan * (persenPajakServis / 100);
    double grandTotal = totalTagihan + nominalPajak;
    double perOrang = grandTotal / jumlahOrang;

    return {
      'pajak': nominalPajak,
      'totalSemua': grandTotal,
      'perOrang': perOrang,
    };
  }
}