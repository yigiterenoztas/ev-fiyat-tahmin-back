import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sonuc_ekrani.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController totalRoomsController = TextEditingController();
  final TextEditingController populationController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController householdsController = TextEditingController();
  final TextEditingController bedroomsController = TextEditingController();

  String? selectedOceanProximity;
  final List<String> oceanProximityOptions = [
    'Körfeze Yakın',
    'Okyanusa 1 Saatten Az',
    'İç Bölge',
    'Okyanusa Yakın',
    'Ada',
  ];

  String _mapOceanProximity(String? value) {
    switch (value) {
      case 'Körfeze Yakın':
        return 'NEAR BAY';
      case 'Okyanusa 1 Saatten Az':
        return '<1H OCEAN';
      case 'İç Bölge':
        return 'INLAND';
      case 'Okyanusa Yakın':
        return 'NEAR OCEAN';
      case 'Ada':
        return 'ISLAND';
      default:
        return 'INLAND';
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> inputData = {
        "longitude": double.parse(longitudeController.text),
        "latitude": double.parse(latitudeController.text),
        "housing_median_age": double.parse(ageController.text),
        "total_rooms": double.parse(totalRoomsController.text),
        "population": double.parse(populationController.text),
        "median_income": double.parse(incomeController.text),
        "households": double.parse(householdsController.text),
        "total_bedrooms": double.parse(bedroomsController.text),
        "ocean_proximity": _mapOceanProximity(selectedOceanProximity),
      };

      try {
        final response = await http.post(
          Uri.parse("http://192.168.233.43:8000/tahmin"), // API adresin
          headers: {"Content-Type": "application/json"},
          body: json.encode(inputData),
        );

        print("📨 Gönderilen veri: $inputData");
        print("📬 Gelen ham yanıt: ${response.body}");

        if (response.statusCode == 200) {
          final result = json.decode(response.body);

          print("✅ JSON decode edildi: $result");

          if (result["predicted_price"] != null) {
            double tahmin = result["predicted_price"] * 100000;

            print("🎯 Tahmin (çarpılmış): $tahmin");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(predictedPrice: tahmin),
              ),
            );
          } else {
            print("⚠️ predicted_price null geldi.");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Tahmin sonucu alınamadı.")),
            );
          }
        } else {
          print("❌ Sunucu başarısız yanıt verdi: ${response.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sunucudan yanıt alınamadı.")),
          );
        }
      } catch (e) {
        print("🚨 HATA: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bağlantı kurulamadı.")),
        );
      }
    }
  }

  String? _validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Pozitif bir sayı giriniz';
    }
    return null;
  }

  String? _validateCoordinate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bu alan boş bırakılamaz';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Geçerli bir sayı giriniz';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ev Bilgileri Girin'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(controller: longitudeController, label: 'Boylam (Longitude)', customValidator: _validateCoordinate),
                _buildTextField(controller: latitudeController, label: 'Enlem (Latitude)', customValidator: _validateCoordinate),
                _buildTextField(controller: ageController, label: 'Ev Yaşı'),
                _buildTextField(controller: totalRoomsController, label: 'Toplam Oda Sayısı'),
                _buildTextField(controller: populationController, label: 'Semt Nüfusu'),
                _buildTextField(controller: incomeController, label: 'Ortalama Gelir'),
                _buildTextField(controller: householdsController, label: 'Hane Sayısı'),
                _buildTextField(controller: bedroomsController, label: 'Yatak Odası Sayısı'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedOceanProximity,
                  items: oceanProximityOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Denize Yakınlık',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null ? 'Bu alanı seçiniz' : null,
                  onChanged: (value) {
                    setState(() {
                      selectedOceanProximity = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  child: const Text('Hesapla'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, String? Function(String?)? customValidator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: customValidator ?? _validatePositiveNumber,
      ),
    );
  }
}
