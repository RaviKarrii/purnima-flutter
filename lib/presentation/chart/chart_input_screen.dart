import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chart_provider.dart';
import '../providers/dasa_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/vedic_background.dart';
import 'chart_display_screen.dart';
import '../dasa/dasa_screen.dart';
import '../widgets/vedic_card.dart';
import '../unified_astrology_screen.dart';

class ChartInputScreen extends StatefulWidget {
  final bool isDasa;
  const ChartInputScreen({super.key, this.isDasa = false});

  @override
  State<ChartInputScreen> createState() => _ChartInputScreenState();
}

class _ChartInputScreenState extends State<ChartInputScreen> {
  final _placeController = TextEditingController(text: 'Hyderabad');
  final _latController = TextEditingController(text: '17.3850');
  final _lngController = TextEditingController(text: '78.4867');
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.isDasa ? settings.getString('nav_dasa') : settings.getString('chart_input_title'))),
      body: VedicBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              VedicCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _placeController,
                        decoration: InputDecoration(labelText: settings.getString('place_name')),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _latController,
                              decoration: InputDecoration(labelText: settings.getString('latitude')),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _lngController,
                              decoration: InputDecoration(labelText: settings.getString('longitude')),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: InputDecoration(labelText: settings.getString('date')),
                                child: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectTime(context),
                              child: InputDecorator(
                                decoration: InputDecoration(labelText: settings.getString('time')),
                                child: Text(_selectedTime.format(context)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _generateChart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(widget.isDasa ? settings.getString('nav_dasa') : settings.getString('generate_chart')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _generateChart() {
    final birthTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    ).toIso8601String();

    // Always load both Chart and Dasa
    final lat = double.tryParse(_latController.text) ?? 0.0;
    final lng = double.tryParse(_lngController.text) ?? 0.0;
    final place = _placeController.text;

    context.read<ChartProvider>().loadChart(birthTime, lat, lng, place);
    context.read<DasaProvider>().loadDasa(birthTime, lat, lng);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UnifiedAstrologyScreen()),
    );
  }
}
