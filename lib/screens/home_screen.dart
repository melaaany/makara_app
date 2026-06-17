import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/keuangan_provider.dart';
import 'tambah_transaksi_screen.dart';
import 'split_bill_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Makara Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.groups),
            tooltip: 'Fitur Patungan Split Bill',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SplitBillScreen())),
          )
        ],
      ),
      body: Consumer<KeuanganProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ringkasan Total Saldo
                Card(
                  color: Colors.teal[50],
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Saldo Gabungan', style: TextStyle(fontSize: 13, color: Colors.black54)),
                            const SizedBox(height: 4),
                            Text(currencyFormat.format(provider.totalSaldoKeseluruhan),
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                          ],
                        ),
                        const Icon(Icons.account_balance_wallet, size: 36, color: Colors.teal),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Banner Pengingat Otomatis "Rem Jajan"
                if (provider.statusPeringatanNongkrong != "Aman")
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber[700]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.amber[900]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            provider.statusPeringatanNongkrong,
                            style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Visualisasi Alokasi Kantung Menggunakan FL Chart
                const Text('Proporsi Kantung Saku', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 160,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: provider.daftarKantung.map((kantung) {
                        return PieChartSectionData(
                          color: kantung.jenisKategori == 'HIDUP' ? Colors.blue :
                          kantung.jenisKategori == 'NONGKRONG' ? Colors.orange :
                          kantung.jenisKategori == 'KULIAH' ? Colors.purple : Colors.green,
                          value: kantung.saldo <= 0 ? 1 : kantung.saldo,
                          title: kantung.nama.split(' ')[1],
                          radius: 45,
                          titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // List Daftar Kantung Saku
                const Text('Kantung Anggaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.daftarKantung.length,
                  itemBuilder: (context, index) {
                    final kantung = provider.daftarKantung[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kantung.jenisKategori == 'HIDUP' ? Colors.blue[100] :
                          kantung.jenisKategori == 'NONGKRONG' ? Colors.orange[100] :
                          kantung.jenisKategori == 'KULIAH' ? Colors.purple[100] : Colors.green[100],
                          child: Icon(kantung.jenisKategori == 'GEMBOK' ? Icons.lock : Icons.folder_special, size: 18),
                        ),
                        title: Text(kantung.nama, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        subtitle: Text('Alokasi Awal: ${currencyFormat.format(kantung.alokasiAwal)}', style: const TextStyle(fontSize: 11)),
                        trailing: Text(currencyFormat.format(kantung.saldo),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kantung.saldo < 100000 ? Colors.red : Colors.black)),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TambahTransaksiScreen())),
      ),
    );
  }
}