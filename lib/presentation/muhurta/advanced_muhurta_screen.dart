import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/muhurta_provider.dart';
import '../providers/panchang_provider.dart';
import '../providers/settings_provider.dart';
import '../../data/models/muhurta_model.dart';
import '../widgets/vedic_card.dart';

class AdvancedMuhurtaScreen extends StatefulWidget {
  const AdvancedMuhurtaScreen({super.key});

  @override
  State<AdvancedMuhurtaScreen> createState() => _AdvancedMuhurtaScreenState();
}

class _AdvancedMuhurtaScreenState extends State<AdvancedMuhurtaScreen> {
  String _selectedType = 'marriage';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  final Map<String, String> _types = {
    'vehicle': 'Vehicle Purchase',
    'marriage': 'Marriage',
    'griha-pravesh': 'Griha Pravesh',
    'business': 'New Business',
    'namakarana': 'Namakarana',
    'property': 'Property Purchase',
  };

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
           if (_endDate.isBefore(_startDate)) {
             _endDate = _startDate.add(const Duration(days: 1));
           }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _search() {
    final panchang = context.read<PanchangProvider>().panchang;
    if (panchang == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not loaded. Please wait.')),
      );
      return;
    }
    
    context.read<MuhurtaProvider>().loadAdvancedMuhurta(
      type: _selectedType,
      start: _startDate,
      end: _endDate,
      lat: panchang.latitude ?? 0,
      lng: panchang.longitude ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(settings.getString('nav_muhurta') ?? 'Advanced Muhurta')),
      body: Column(
        children: [
          VedicCard(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(labelText: 'Muhurta Type'),
                    items: _types.entries.map((e) {
                      return DropdownMenuItem(value: e.key, child: Text(e.value));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => _selectDate(context, true),
                          child: Text('Start: ${DateFormat('yyyy-MM-dd').format(_startDate)}'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () => _selectDate(context, false),
                          child: Text('End: ${DateFormat('yyyy-MM-dd').format(_endDate)}'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _search,
                    child: const Text('Search Muhurtas'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<MuhurtaProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
                }
                if (provider.error != null) {
                  return Center(child: Text('Error: ${provider.error}'));
                }
                
                final list = provider.advancedMuhurta;
                if (list == null || list.isEmpty) {
                  return const Center(child: Text('No muhurtas found (or search not started).'));
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final slot = list[index];
                    return _buildSlotCard(context, slot);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCard(BuildContext context, MuhurtaSlot slot) {
    if (slot.startTime == null || slot.endTime == null) return const SizedBox();
    
    final start = DateTime.parse(slot.startTime!).toLocal();
    final end = DateTime.parse(slot.endTime!).toLocal();
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return VedicCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateFormat.format(start), style: const TextStyle(fontWeight: FontWeight.bold)),
                Chip(
                   label: Text(slot.quality ?? 'Unknown', style: const TextStyle(color: Colors.white, fontSize: 10)),
                   backgroundColor: (slot.quality?.toLowerCase() == 'good') ? Colors.green : Colors.orange,
                   padding: EdgeInsets.zero,
                   visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${timeFormat.format(start)} - ${timeFormat.format(end)}', style: Theme.of(context).textTheme.titleMedium),
            if (slot.positiveFactors != null && slot.positiveFactors!.isNotEmpty) ...[
               const SizedBox(height: 8),
               const Text('Positive Factors:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
               ...slot.positiveFactors!.map((e) => Text('• $e', style: const TextStyle(fontSize: 12, color: Colors.green))),
            ],
             if (slot.negativeFactors != null && slot.negativeFactors!.isNotEmpty) ...[
               const SizedBox(height: 8),
               const Text('Negative Factors:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
               ...slot.negativeFactors!.map((e) => Text('• $e', style: const TextStyle(fontSize: 12, color: Colors.red))),
            ],
          ],
        ),
      ),
    );
  }
}
