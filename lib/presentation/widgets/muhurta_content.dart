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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color? choghadiyaColor;
    if (c.color != null) {
      try {
        String hex = c.color!.replaceAll('#', '');
        if (hex.length == 6) hex = 'FF$hex';
        choghadiyaColor = Color(int.parse(hex, radix: 16));
      } catch (e) {
        debugPrint('Error parsing color: ${c.color}');
      }
    }

    Color cardColor;
    Color textColor;
    
    if (isDark) {
       cardColor = Theme.of(context).cardTheme.color ?? const Color(0xFF1E1E1E);
       textColor = choghadiyaColor ?? Colors.white;
    } else {
       cardColor = choghadiyaColor ?? Colors.grey.shade200;
       textColor = Colors.black;
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(right: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(settings.getString(c.name?.toLowerCase() ?? '') ?? c.name ?? '', 
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 4),
            Text('${PanchangUtils.formatTime(c.startTime)} - ${PanchangUtils.formatTime(c.endTime)}', 
              style: TextStyle(fontSize: 12, color: isDark ? Theme.of(context).primaryColor.withOpacity(0.9) : const Color(0xFF8B0000))),
            const SizedBox(height: 4),
            Text(settings.getString(c.nature?.toLowerCase() ?? 'neutral') ?? c.nature ?? '', 
              style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildHoraSection(BuildContext context, MuhurtaResult muhurta, SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(settings.getString('day'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildHoraList(context, muhurta.dayHora),
        const SizedBox(height: 16),
        Text(settings.getString('night'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return VedicCard(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(h.planet ?? '', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${PanchangUtils.formatTime(h.startTime)} - ${PanchangUtils.formatTime(h.endTime)}', 
            style: TextStyle(fontSize: 12, color: isDark ? Theme.of(context).primaryColor.withOpacity(0.9) : const Color(0xFF8B0000))),
        ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text('${PanchangUtils.formatTime(time?.startTime)} - ${PanchangUtils.formatTime(time?.endTime)}', 
           style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Theme.of(context).primaryColor : const Color(0xFF8B0000))),
      ],
    );
  }
}
