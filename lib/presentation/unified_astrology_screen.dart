import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'providers/chart_provider.dart';
import 'providers/dasa_provider.dart';
import 'chart/chart_display_screen.dart';
import 'dasa/dasa_screen.dart';

class UnifiedAstrologyScreen extends StatefulWidget {
  const UnifiedAstrologyScreen({super.key});

  @override
  State<UnifiedAstrologyScreen> createState() => _UnifiedAstrologyScreenState();
}

class _UnifiedAstrologyScreenState extends State<UnifiedAstrologyScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(settings.getString('nav_chart')), // Or a new string like "Astrology"
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: settings.getString('nav_chart')),
            Tab(text: settings.getString('nav_dasa')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ChartDisplayTab(),
          DasaDisplayTab(),
        ],
      ),
    );
  }
}

// Wrapper for ChartDisplayScreen to remove Scaffold/AppBar
class ChartDisplayTab extends StatelessWidget {
  const ChartDisplayTab({super.key});

  @override
  Widget build(BuildContext context) {
    // We reuse the body logic from ChartDisplayScreen
    // But ChartDisplayScreen returns a Scaffold. We need to extract the body.
    // Ideally, we should refactor ChartDisplayScreen. 
    // For now, let's just instantiate ChartDisplayScreen but it might double AppBars.
    // Better: Refactor ChartDisplayScreen to be a widget we can use here.
    return const ChartContent();
  }
}

// Wrapper for DasaScreen
class DasaDisplayTab extends StatelessWidget {
  const DasaDisplayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const DasaContent();
  }
}
