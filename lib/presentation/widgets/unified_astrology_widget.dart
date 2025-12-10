import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/chart_provider.dart';
import '../providers/dasa_provider.dart';
import '../widgets/vedic_background.dart';
import '../widgets/vedic_card.dart';
import '../chart/south_indian_chart.dart';
import '../../data/models/dasa_model.dart';
import 'package:intl/intl.dart';

class UnifiedAstrologyWidget extends StatefulWidget {
  final VoidCallback onNewChart;
  
  const UnifiedAstrologyWidget({super.key, required this.onNewChart});

  @override
  State<UnifiedAstrologyWidget> createState() => _UnifiedAstrologyWidgetState();
}

class _UnifiedAstrologyWidgetState extends State<UnifiedAstrologyWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   // Back/New Chart Button
                   IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: widget.onNewChart,
                   ),
                   Expanded(
                     child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: [
                        Tab(text: settings.getString('nav_chart')),
                        Tab(text: settings.getString('nav_dasa')),
                      ],
                                     ),
                   ),
                   const SizedBox(width: 48), // Balance for back button
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              ChartContent(),
              DasaContent(),
            ],
          ),
        ),
      ],
    );
  }
}

class ChartContent extends StatelessWidget {
  const ChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return VedicBackground(
        child: Consumer<ChartProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
            }
            if (provider.error != null) {
              return Center(child: Text('${settings.getString('error')}: ${provider.error}')); 
            }
            final chart = provider.chart; 
            if (chart == null) {
              return Center(child: Text(settings.getString('no_data'))); 
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   if (chart.planetaryPositions != null && chart.ascendant != null)
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          children: [
                            SouthIndianChart(
                              planets: chart.planetaryPositions!,
                              ascendant: chart.ascendant!,
                            ),
                            const SizedBox(height: 24),
                            Text(settings.getString('details'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            ...chart.planetaryPositions!.map((planet) {
                              final degree = planet.degreeInRashi ?? 0;
                              final d = degree.floor();
                              final m = ((degree - d) * 60).floor();
                              final degStr = '$d° $m\'';
                              final isRetro = planet.retrograde == true;
                              
                              return VedicCard(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                       Container(
                                         width: 40,
                                         height: 40,
                                         decoration: BoxDecoration(
                                           color: Theme.of(context).primaryColor.withOpacity(0.1),
                                           shape: BoxShape.circle,
                                         ),
                                         alignment: Alignment.center,
                                         child: Text(
                                           planet.planetName?.substring(0, 2) ?? '??',
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold, 
                                             color: Theme.of(context).primaryColor
                                           ),
                                         ),
                                       ),
                                       const SizedBox(width: 16),
                                       Expanded(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Row(
                                               children: [
                                                 Text(
                                                   planet.planetName ?? settings.getString('unknown'), 
                                                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                                 ),
                                                 if (isRetro)
                                                   Container(
                                                     margin: const EdgeInsets.only(left: 8),
                                                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                     decoration: BoxDecoration(
                                                       color: Theme.of(context).colorScheme.error,
                                                       borderRadius: BorderRadius.circular(4),
                                                     ),
                                                     child: Text('R', style: TextStyle(color: Theme.of(context).colorScheme.onError, fontSize: 10, fontWeight: FontWeight.bold)),
                                                   ),
                                               ],
                                             ),
                                             const SizedBox(height: 4),
                                             Row(
                                               children: [
                                                 Text('${settings.getString('house')} ${planet.houseNumber}'),
                                                 const SizedBox(width: 8),
                                                 const Text('•', style: TextStyle(color: Colors.grey)),
                                                 const SizedBox(width: 8),
                                                 Text(planet.rashiName ?? ''),
                                               ],
                                             ),
                                           ],
                                         ),
                                       ),
                                       Text(degStr, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Monospace')),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
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
        trailing: (dasa.subPeriods == null || dasa.subPeriods!.isEmpty) ? const SizedBox.shrink() : null,
        children: dasa.subPeriods?.map((subDasa) => _buildDasaItem(context, subDasa, depth + 1)).toList() ?? [],
      ),
    );
  }
}
