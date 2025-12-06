import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/dasa_model.dart';
import '../providers/dasa_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/vedic_background.dart';
import '../widgets/vedic_card.dart';

class DasaScreen extends StatelessWidget {
  const DasaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(settings.getString('nav_dasa'))),
      body: const DasaContent(),
    );
  }
}

class DasaContent extends StatelessWidget {
  const DasaContent({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return VedicBackground(
        child: Consumer<DasaProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
            }
            if (provider.error != null) {
              return Center(child: Text('${settings.getString('error')}: ${provider.error}'));
            }
            final dasaList = provider.dasa;
            if (dasaList == null || dasaList.isEmpty) {
              return Center(child: Text(settings.getString('no_data')));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: dasaList.length,
              itemBuilder: (context, index) {
                return _buildDasaItem(context, dasaList[index], 0);
              },
            );
          },
        ),
      );
  }

  Widget _buildDasaItem(BuildContext context, DasaResult dasa, int depth) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final startDate = dasa.startDate != null ? dateFormat.format(DateTime.parse(dasa.startDate!)) : '';
    final endDate = dasa.endDate != null ? dateFormat.format(DateTime.parse(dasa.endDate!)) : '';

    return VedicCard(
      margin: EdgeInsets.only(bottom: 8, left: depth * 16.0),
      child: ExpansionTile(
        title: Text(
          dasa.planet ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        subtitle: Text('$startDate - $endDate'),
        children: dasa.subPeriods?.map((subDasa) => _buildDasaItem(context, subDasa, depth + 1)).toList() ?? [],
      ),
    );
  }
}
