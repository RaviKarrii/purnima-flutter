import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils.dart';
import '../../data/models/muhurta_model.dart';
import '../providers/muhurta_provider.dart';
import '../providers/settings_provider.dart';
import 'vedic_background.dart';
import 'vedic_card.dart';

class MuhurtaContent extends StatelessWidget {
  const MuhurtaContent({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return VedicBackground(
      child: Consumer<MuhurtaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
          }
          if (provider.error != null) {
            return Center(child: Text('${settings.getString('error')}: ${provider.error}'));
          }
          final muhurta = provider.muhurta;
          if (muhurta == null) {
            return Center(child: Text(settings.getString('no_data')));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, settings.getString('choghadiya')),
                _buildChoghadiyaSection(context, muhurta, settings),
                const SizedBox(height: 24),
                _buildSectionTitle(context, settings.getString('hora')),
                _buildHoraSection(context, muhurta, settings),
                const SizedBox(height: 24),
                _buildInauspiciousTimes(context, muhurta, settings),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildChoghadiyaSection(BuildContext context, MuhurtaResult muhurta, SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(settings.getString('day'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _buildChoghadiyaList(context, muhurta.dayChoghadiya, settings),
        const SizedBox(height: 16),
        Text(settings.getString('night'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _buildChoghadiyaList(context, muhurta.nightChoghadiya, settings),
      ],
    );
  }

  Widget _buildChoghadiyaList(BuildContext context, List<Choghadiya>? list, SettingsProvider settings) {
    if (list == null || list.isEmpty) return const SizedBox();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: list.map((c) => _buildChoghadiyaCard(context, c, settings)).toList(),
      ),
    );
  }

  Widget _buildChoghadiyaCard(BuildContext context, Choghadiya c, SettingsProvider settings) {
    Color color;
    String natureKey = c.nature?.toLowerCase() ?? 'neutral';

    // Same logic as HomeScreen for consistent coloring
    const goodNatures = [
      'good', 'shubh', 'labh', 'amrit', 
      'शुभ', 'लाभ', 'अमृत', // Hindi
      'శుభం', 'లాభం', 'అమృతం', // Telugu (Exact API strings)
      'शुभम्', 'लाभः', 'अमृतम्', // Sanskrit
      'நல்லது', 'சுபம்', 'லாபம்', 'அமிர்தம்', // Tamil
      'ಶುಭ', 'ಲಾಭ', 'ಅಮೃತ', // Kannada
    ];
    
    const badNatures = [
      'bad', 'rog', 'udveg', 'kaal', 'kal', 
      'अशुभ', 'रोग', 'उद्वेग', 'काल', // Hindi
      'అశుభం', 'రోగం', 'ఉద్వేగం', 'కాలం', // Telugu (Exact API strings)
      'अशुभम्', 'रोगः', 'उद्वेगः', 'कालः', // Sanskrit
      'கெட்டது', 'ரோகம்', 'உத்வேகம்', 'காலம்', // Tamil
      'ಅಶುಭ', 'ರೋಗ', 'ಉದ್ವೇಗ', 'ಕಾಲ', // Kannada
    ];

    if (goodNatures.contains(natureKey)) {
      color = Colors.green.shade100;
    } else if (badNatures.contains(natureKey)) {
      color = Colors.red.shade100;
    } else {
      color = Colors.grey.shade200;
    }

    return Card(
      color: color,
      margin: const EdgeInsets.only(right: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(settings.getString(c.name?.toLowerCase() ?? '') ?? c.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${PanchangUtils.formatTime(c.startTime)} - ${PanchangUtils.formatTime(c.endTime)}', style: const TextStyle(fontSize: 12)),
            Text(settings.getString(natureKey) ?? c.nature ?? '', style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildHoraSection(BuildContext context, MuhurtaResult muhurta, SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(settings.getString('day'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _buildHoraList(context, muhurta.dayHora),
        const SizedBox(height: 16),
        Text(settings.getString('night'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _buildHoraList(context, muhurta.nightHora),
      ],
    );
  }

  Widget _buildHoraList(BuildContext context, List<Hora>? list) {
    if (list == null || list.isEmpty) return const SizedBox();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: list.map((h) => _buildHoraCard(context, h)).toList(),
      ),
    );
  }

  Widget _buildHoraCard(BuildContext context, Hora h) {
    return VedicCard(
      margin: const EdgeInsets.only(right: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(h.planet ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${PanchangUtils.formatTime(h.startTime)} - ${PanchangUtils.formatTime(h.endTime)}', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildInauspiciousTimes(BuildContext context, MuhurtaResult muhurta, SettingsProvider settings) {
    return VedicCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTimeRow(context, settings.getString('rahu_kalam'), muhurta.rahuKalam),
            const Divider(),
            _buildTimeRow(context, settings.getString('yamagandam'), muhurta.yamagandam),
            const Divider(),
            _buildTimeRow(context, settings.getString('gulika_kalam'), muhurta.gulikaKalam),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(BuildContext context, String label, TimeSpan? time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('${PanchangUtils.formatTime(time?.startTime)} - ${PanchangUtils.formatTime(time?.endTime)}'),
      ],
    );
  }
}
