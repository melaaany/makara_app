import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/kantung_model.dart';
import 'models/transaksi_model.dart';
import 'providers/keuangan_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Penyimpanan Hive Lokal
  await Hive.initFlutter();

  // Registrasi Serializer Adapter Binary dari Hive Generator
  Hive.registerAdapter(KantungModelAdapter());
  Hive.registerAdapter(TransaksiModelAdapter());

  // Membuka File Box Database Fisik
  await Hive.openBox<KantungModel>('kantungBox');
  await Hive.openBox<TransaksiModel>('transaksiBox');

  runApp(const MakaraApplication());
}

class MakaraApplication extends StatelessWidget {
  const MakaraApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => KeuanganProvider()..inisialisasiDatabase(),
        ),
      ],
      child: MaterialApp(
        title: 'Makara Student Financial',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, primary: Colors.teal[700]),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}