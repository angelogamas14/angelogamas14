import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import '../models/bmi.dart';
import '../services/bmi_service.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? _bmi;
  String? _classification;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _heightController,
                        decoration: const InputDecoration(
                          labelText: 'Height (cm)',
                          prefixIcon: Icon(Icons.height),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          prefixIcon: Icon(Icons.monitor_weight),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.calculate),
                        label: const Text('Calculate'),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          final heightMeters = double.tryParse(_heightController.text.replaceAll(',', '.'));
                          final weightKg = double.tryParse(_weightController.text.replaceAll(',', '.'));
                          if (heightMeters == null || weightKg == null) return;
                          final meters = heightMeters > 3 ? heightMeters / 100 : heightMeters; // cm -> m
                          final bmi = BmiRecord.calculateBmi(heightMeters: meters, weightKg: weightKg);
                          final classif = BmiRecord.classify(bmi);
                          setState(() {
                            _bmi = double.parse(bmi.toStringAsFixed(1));
                            _classification = classif;
                          });
                          final record = BmiRecord(
                            userId: auth.currentUser!.id,
                            heightMeters: meters,
                            weightKg: weightKg,
                            bmi: bmi,
                            recordedAt: DateTime.now(),
                          );
                          await BmiService().addBmi(record);
                          if (!mounted) return;
                          context.read<AppProvider>().setLatestBmi(record);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_bmi != null) _resultCard(_bmi!, _classification!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultCard(double bmi, String classification) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('BMI: ${bmi.toStringAsFixed(1)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Result: $classification', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(_adviceFor(classification)),
          ],
        ),
      ),
    );
  }

  String _adviceFor(String cls) {
    switch (cls) {
      case 'Underweight':
        return 'Consider increasing calorie intake with nutrient-dense foods.';
      case 'Normal':
        return 'Maintain a balanced diet and regular exercise.';
      case 'Overweight':
        return 'Increase physical activity and monitor calorie intake.';
      case 'Obesity':
        return 'Consult a healthcare provider for a personalized plan.';
      default:
        return '';
    }
  }
}
