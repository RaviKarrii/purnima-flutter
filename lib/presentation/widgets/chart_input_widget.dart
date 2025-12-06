import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chart_provider.dart';
import '../providers/dasa_provider.dart';
import '../providers/settings_provider.dart';
import 'vedic_background.dart';
import 'vedic_card.dart';
import 'location_search_delegate.dart';

class ChartInputWidget extends StatefulWidget {
  final VoidCallback onGenerate;

  const ChartInputWidget({super.key, required this.onGenerate});

  @override
  State<ChartInputWidget> createState() => _ChartInputWidgetState();
}

class _ChartInputWidgetState extends State<ChartInputWidget> {
  final _placeController = TextEditingController(text: 'Hyderabad');
  final _latController = TextEditingController(text: '17.3850');
  final _lngController = TextEditingController(text: '78.4867');
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

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

    final lat = double.tryParse(_latController.text) ?? 0.0;
    final lng = double.tryParse(_lngController.text) ?? 0.0;
    final place = _placeController.text;

    context.read<ChartProvider>().loadChart(birthTime, lat, lng, place);
    context.read<DasaProvider>().loadDasa(birthTime, lat, lng);

    widget.onGenerate();
  }

  bool _isManualLocation = false;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(settings.getString('chart_input_title'),
              style:
                  Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          // Place Name with Search Icon
          TextField(
            controller: _placeController,
            readOnly: !_isManualLocation, // Read-only if using search, editable if manual
            onTap: _isManualLocation ? null : () async {
              final city = await showSearch(
                context: context,
                delegate: LocationSearchDelegate(),
              );
              if (city != null && mounted) {
                setState(() {
                  _placeController.text = city.name;
                  _latController.text = city.latitude.toString();
                  _lngController.text = city.longitude.toString();
                });
              }
            },
            decoration: InputDecoration(
              labelText: settings.getString('place_name'),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.location_city),
              suffixIcon: _isManualLocation ? null : const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          // Manual Location Toggle
          // Manual Location Toggle
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: SwitchListTile(
              title: Text(settings.getString('use_manual_coords') ?? 'Enter coordinates manually', style: const TextStyle(fontSize: 14)),
              value: _isManualLocation,
              onChanged: (value) {
                setState(() {
                  _isManualLocation = value;
                });
              },
              dense: true,
              activeColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            ),
          ),

          if (_isManualLocation) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latController,
                    decoration: InputDecoration(
                      labelText: settings.getString('latitude'),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _lngController,
                    decoration: InputDecoration(
                      labelText: settings.getString('longitude'),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: settings.getString('date'),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: settings.getString('time'),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.access_time),
                    ),
                    child: Text(_selectedTime.format(context)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _generateChart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(settings.getString('generate_chart'),
                style: const TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
