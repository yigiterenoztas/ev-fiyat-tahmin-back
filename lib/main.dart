import 'package:auu/sonuc_ekrani.dart';
import 'package:flutter/material.dart';
import 'giris_ekrani.dart';
import 'sonuc_ekrani.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ev Fiyat Tahmini',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/result': (context) => const ResultScreen(predictedPrice: 0), // default değer
      },
    );
  }
}
