import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double predictedPrice;

  const ResultScreen({super.key, required this.predictedPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahmin Sonucu'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tahmini Ev Fiyatı:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                '₺${predictedPrice.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Yeni Tahmin Yap'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
