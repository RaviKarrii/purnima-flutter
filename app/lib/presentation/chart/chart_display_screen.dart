import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chart_provider.dart';
import '../providers/settings_provider.dart';
import 'south_indian_chart.dart';
import '../widgets/vedic_background.dart';
import '../widgets/vedic_card.dart';
import '../providers/settings_provider.dart'; // Added import for SettingsProvider

class ChartDisplayScreen extends StatelessWidget {
  const ChartDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(settings.getString('your_chart'))),
      body: const ChartContent(),
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
                            ...chart.planetaryPositions!.map((planet) => 
                              VedicCard(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(planet.planetName ?? settings.getString('unknown'), style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text('${settings.getString('house')} ${planet.houseNumber}'),
                                    ],
                                  ),
                                ),
                              )
                            ),
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
