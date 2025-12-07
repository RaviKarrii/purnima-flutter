import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/compatibility_provider.dart';
import '../providers/settings_provider.dart';
import '../../data/models/compatibility_model.dart';
import '../widgets/vedic_card.dart';

class CompatibilityScreen extends StatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // controllers
  final _mDateController = TextEditingController(text: '2025-12-05');
  final _mTimeController = TextEditingController(text: '10:00');
  final _mPlaceController = TextEditingController(text: 'Hyderabad');
  final _mLatController = TextEditingController(text: '17.3850');
  final _mLngController = TextEditingController(text: '78.4867');

  final _fDateController = TextEditingController(text: '2026-05-20');
  final _fTimeController = TextEditingController(text: '15:30');
  final _fPlaceController = TextEditingController(text: 'Hyderabad');
  final _fLatController = TextEditingController(text: '17.3850');
  final _fLngController = TextEditingController(text: '78.4867');

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;
    
    final maleInput = BirthDataInput(
      birthDateTime: "${_mDateController.text}T${_mTimeController.text}:00",
      placeName: _mPlaceController.text,
      latitude: double.parse(_mLatController.text),
      longitude: double.parse(_mLngController.text),
    );

    final femaleInput = BirthDataInput(
      birthDateTime: "${_fDateController.text}T${_fTimeController.text}:00",
      placeName: _fPlaceController.text,
      latitude: double.parse(_fLatController.text),
      longitude: double.parse(_fLngController.text),
    );

    await context.read<CompatibilityProvider>().calculateCompatibility(
      maleData: maleInput,
      femaleData: femaleInput,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compatibility (Asthakoot)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPersonForm("Boy's Details", _mDateController, _mTimeController, _mPlaceController, _mLatController, _mLngController),
              const SizedBox(height: 24),
              _buildPersonForm("Girl's Details", _fDateController, _fTimeController, _fPlaceController, _fLatController, _fLngController),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: const Text('Check Compatibility', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 24),
              Consumer<CompatibilityProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) return const Center(child: CircularProgressIndicator());
                  if (provider.error != null) return Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red));
                  if (provider.result != null) return _buildResult(provider.result!);
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonForm(String title, TextEditingController dateC, TextEditingController timeC, TextEditingController placeC, TextEditingController latC, TextEditingController lngC) {
    return VedicCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextFormField(controller: dateC, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'))),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: timeC, decoration: const InputDecoration(labelText: 'Time (HH:MM)'))),
              ],
            ),
            TextFormField(controller: placeC, decoration: const InputDecoration(labelText: 'Place Name')),
            Row(
              children: [
                Expanded(child: TextFormField(controller: latC, decoration: const InputDecoration(labelText: 'Latitude'))),
                const SizedBox(width: 8),
                Expanded(child: TextFormField(controller: lngC, decoration: const InputDecoration(labelText: 'Longitude'))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(CompatibilityResult res) {
    Color scoreColor;
    final percentage = res.compatibilityPercentage ?? 0.0;
    if (percentage >= 50) {
      scoreColor = Colors.green;
    } else {
      scoreColor = Colors.red;
    }

    return VedicCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score Circle
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                Column(
                  children: [
                    Text("${res.totalScore}", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: scoreColor)),
                    Text("/ ${res.maximumScore}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(res.compatibilityLevel ?? "Unknown", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: scoreColor)),
            const SizedBox(height: 8),
            Text(res.overallAssessment ?? "", textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            const Divider(height: 32),
            
            // Breakdown Table
            const Text("Asthakoot Breakdown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _buildKootaRow("Varna (Work)", res.varnaKoota, 1),
            _buildKootaRow("Vashya (Dominance)", res.vashyaKoota, 2),
            _buildKootaRow("Tara (Destiny)", res.taraKoota, 3),
            _buildKootaRow("Yoni (Mentality)", res.yoniKoota, 4),
            _buildKootaRow("Graha Maitri (Friendship)", res.grahaMaitriKoota, 5),
            _buildKootaRow("Gana (Temperament)", res.ganaKoota, 6),
            _buildKootaRow("Bhakoot (Love)", res.bhakootKoota, 7),
            _buildKootaRow("Nadi (Health)", res.nadiKoota, 8),
          ],
        ),
      ),
    );
  }

  Widget _buildKootaRow(String title, double? score, double max) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text("${score ?? 0} / $max", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

