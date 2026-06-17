import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/keuangan_provider.dart';
import '../models/transaksi_model.dart';

class TambahTransaksiScreen extends StatefulWidget {
  const TambahTransaksiScreen({super.key});

  @override
  State<TambahTransaksiScreen> createState() => _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState extends State<TambahTransaksiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _nominalController = TextEditingController();
  String? _selectedKantungId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<KeuanganProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Catat Mutasi Keuangan'), backgroundColor: Colors.teal[700], foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Deskripsi Keperluan (Misal: Bayar Kos)'),
                validator: (v) => v == null || v.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal Transaksi (Rp)'),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Masukkan nominal valid' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedKantungId,
                hint: const Text('Pilih Sumber Kantung Saku'),
                items: provider.daftarKantung.map((k) {
                  return DropdownMenuItem(value: k.id, child: Text(k.nama));
                }).toList(),
                onChanged: (val) => setState(() => _selectedKantungId = val),
                validator: (v) => v == null ? 'Pilih kantung tujuan' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[700], minimumSize: const Size(double.infinity, 45)),
                child: const Text('Simpan Pengeluaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final tx = TransaksiModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      kantungId: _selectedKantungId!,
                      judul: _judulController.text,
                      nominal: double.parse(_nominalController.text),
                      tanggal: DateTime.now(),
                      isPengeluaran: true,
                    );
                    provider.tambahTransaksi(tx);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}