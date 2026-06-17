import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/keuangan_provider.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final _tagihanController = TextEditingController();
  final _orangController = TextEditingController();
  final _pajakController = TextEditingController(text: '10'); // Default pajak resto 10%
  Map<String, double>? _hasilKalkulasi;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Split Bill - Patungan Mahasiswa'), backgroundColor: Colors.teal[700], foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kalkulasi Pembagian Adil Berkelompok', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: _tagihanController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Nota / Tagihan Pokok (Rp)')),
            TextField(controller: _orangController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Jumlah Anggota Kelompok (Orang)')),
            TextField(controller: _pajakController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Persentase Pajak & Servis (%)')),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[700], minimumSize: const Size(double.infinity, 45)),
              child: const Text('Hitung Patungan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                final double total = double.tryParse(_tagihanController.text) ?? 0;
                final int orang = int.tryParse(_orangController.text) ?? 1;
                final double pajak = double.tryParse(_pajakController.text) ?? 0;

                setState(() {
                  _hasilKalkulasi = Provider.of<KeuanganProvider>(context, listen: false)
                      .hitungMatematikaSplitBill(totalTagihan: total, jumlahOrang: orang, persenPajakServis: pajak);
                });
              },
            ),
            if (_hasilKalkulasi != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(title: const Text('Nominal Pajak/Servis'), trailing: Text(currencyFormat.format(_hasilKalkulasi!['pajak']))),
                      ListTile(title: const Text('Total Tagihan Bersih'), trailing: Text(currencyFormat.format(_hasilKalkulasi!['totalSemua']), style: const TextStyle(fontWeight: FontWeight.bold))),
                      const Divider(),
                      ListTile(
                        title: const Text('Tanggungan Per Orang', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                        trailing: Text(currencyFormat.format(_hasilKalkulasi!['perOrang']), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                      ),
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}