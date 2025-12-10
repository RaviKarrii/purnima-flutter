import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/panchang_provider.dart';
import 'chart/chart_input_screen.dart';
import 'package:app/core/utils.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'widgets/vedic_background.dart';
import 'widgets/vedic_card.dart';
import 'providers/muhurta_provider.dart';
import 'muhurta/muhurta_screen.dart';
import 'muhurta/advanced_muhurta_screen.dart';
import 'compatibility/compatibility_screen.dart';
import 'widgets/muhurta_content.dart';
import 'widgets/chart_input_widget.dart';
import 'widgets/unified_astrology_widget.dart';
import 'providers/dasa_provider.dart';
import 'settings/settings_screen.dart';
import 'providers/settings_provider.dart';
import 'widgets/location_search_delegate.dart';
import '../data/models/muhurta_model.dart';
import '../data/models/panchang_model.dart';
import 'chart/chart_input_screen.dart'; // Deprecated but might be referenced

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  // Removed print from constructor as it can't have body if const. 
  // But wait, I need to remove const to add body.
  // Actually, I'll just keep it const and rely on initState print.
  // If initState isn't called, then the widget isn't being mounted.


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  bool _showChartResults = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PanchangProvider>().loadPanchang().then((_) {
        // After panchang, load muhurta for the same location
        final p = context.read<PanchangProvider>().panchang;
        if (p != null && mounted) {
           context.read<MuhurtaProvider>().loadMuhurta(p.latitude ?? 0, p.longitude ?? 0);
        }
      });
    });
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const PanchangView();
      case 1:
        return _showChartResults
            ? UnifiedAstrologyWidget(
                onNewChart: () => setState(() => _showChartResults = false),
              )
            : ChartInputWidget(
                onGenerate: () => setState(() => _showChartResults = true),
              );
      case 2:
        return const MuhurtaViewWrapper();
      case 3:
        return const ToolsView();
      default:
        return const PanchangView();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch to rebuild when settings change
    final settings = context.watch<SettingsProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(settings.getString('app_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
             // Muhurta - try to load data
             final panchang = context.read<PanchangProvider>().panchang;
             if (panchang != null && panchang.latitude != null && panchang.longitude != null) {
                context.read<MuhurtaProvider>().loadMuhurta(panchang.latitude!, panchang.longitude!);
             } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(settings.getString('location_not_available_for_muhurta'))),
                 );
             }
          }
          setState(() {
            _currentIndex = index;
            if (index != 1) {
              _showChartResults = false; // Reset chart view when moving away? Optional
            }
          });
        },
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: settings.getString('nav_panchang'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome),
            label: settings.getString('nav_chart'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.access_time),
            label: settings.getString('nav_muhurta'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.grid_view),
            label: "Tools",
          ),
        ],
      ),
    );
  }
}


class ToolsView extends StatelessWidget {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildToolCard(
          context, 
          'Advanced Muhurta Search', 
          'Search for specific muhurtas (Marriage, vehicle, etc) across dates.', 
          Icons.search,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdvancedMuhurtaScreen())),
        ),
        _buildToolCard(
          context, 
          'Compatibility Matching (Asthakoot)', 
          'Check marriage compatibility between two charts.', 
          Icons.favorite,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompatibilityScreen())),
        ),
      ],
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}

class MuhurtaViewWrapper extends StatelessWidget {
  const MuhurtaViewWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MuhurtaContent();
  }
}

class PanchangView extends StatelessWidget {
  const PanchangView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      body: VedicBackground(
        child: Consumer<PanchangProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${provider.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.loadPanchang(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final panchang = provider.panchang;
            final settings = context.read<SettingsProvider>();
            if (panchang == null) {
              return Center(child: Text(settings.getString('no_data')));
            }

            return RefreshIndicator(
              onRefresh: () async {
                 await context.read<PanchangProvider>().loadPanchang();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(context, panchang),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildPanchangBadge(context, settings.getString('tithi'), panchang.tithi),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildPanchangBadge(context, settings.getString('vara'), panchang.vara != null ? [panchang.vara!] : []),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildPanchangBadge(context, settings.getString('nakshatra'), panchang.nakshatra),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildPanchangBadge(context, settings.getString('yoga'), panchang.yoga),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildPanchangBadge(context, settings.getString('karana'), panchang.karana),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildCurrentChoghadiya(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSunMoonCard(context, panchang),
                    const SizedBox(height: 24),
                    // Removed bottom _buildCurrentChoghadiya
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentChoghadiya(BuildContext context) {
    final muhurta = context.watch<MuhurtaProvider>().muhurta;
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (muhurta == null) {
      return const SizedBox(); 
    }
    
    // Find current choghadiya
    final now = DateTime.now(); // Local time
    final all = [...?muhurta.dayChoghadiya, ...?muhurta.nightChoghadiya];
    
    Choghadiya? current;
    for (final c in all) {
      if (c.startTime != null && c.endTime != null) {
         try {
           final start = DateTime.parse(c.startTime!).toLocal();
           final end = DateTime.parse(c.endTime!).toLocal();

           if (now.isAfter(start) && now.isBefore(end)) {
             current = c;
             break;
           }
         } catch (e) {
           print("CHOGHADIYA PARSE ERROR: $e");
         }
      }
    }

    if (current == null) return const SizedBox();

    // Update Home Widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeWidget.saveWidgetData<String>('choghadiya_name', current!.name ?? '');
      HomeWidget.saveWidgetData<String>('choghadiya_time', '${PanchangUtils.formatTime(current.startTime)} - ${PanchangUtils.formatTime(current.endTime)}');
      HomeWidget.updateWidget(name: 'ChoghadiyaWidgetProvider', androidName: 'ChoghadiyaWidgetProvider');
    });

    Color? choghadiyaColor;
    if (current.color != null) {
      try {
        // Parse #RRGGBB
        String hex = current.color!.replaceAll('#', '');
        if (hex.length == 6) {
           hex = 'FF$hex';
        }
        choghadiyaColor = Color(int.parse(hex, radix: 16));
      } catch (e) {
        print("Error parsing color: ${current.color}");
      }
    }

    // Colors based on theme
    Color cardBgColor;
    Color titleColor;
    Color nameColor;
    Color timeColor;

    if (isDark) {
      cardBgColor = Theme.of(context).cardTheme.color ?? const Color(0xFF1E1E1E);
      // If we have a choghadiya color, use it for the Name, otherwise primary
      titleColor = Theme.of(context).primaryColor; // Saffron
      nameColor = choghadiyaColor ?? Colors.white; 
      // Ensure name color is visible on dark bg. If it's too dark (like dark red), lighten it?
      // But typically choghadiya colors are light/pastel-ish or standard. 
      // Let's assume they are okay, or stick to Safety:
      // Actually, if choghadiyaColor is the "Meaning" (Red=Bad, Green=Good), we want to preserve that hue.
      timeColor = Theme.of(context).primaryColor.withOpacity(0.8);
    } else {
      cardBgColor = choghadiyaColor ?? Colors.grey.shade200;
      titleColor = Colors.black87; // Force dark on pastel bg
      nameColor = Colors.black;
      timeColor = const Color(0xFF8B0000);
    }

    return VedicCard(
      backgroundColor: cardBgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(settings.getString('choghadiya'), style: Theme.of(context).textTheme.titleSmall?.copyWith(color: titleColor, fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
           Text(settings.getString(current.name?.toLowerCase() ?? '') ?? current.name ?? '', 
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, height: 1.2, color: nameColor)),
           
           const SizedBox(height: 8),
           Text('${PanchangUtils.formatTime(current.startTime)} - ${PanchangUtils.formatTime(current.endTime)}', 
             style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: timeColor)),
        ],
      )
    );
  }

  Widget _buildPanchangBadge(BuildContext context, String title, List<PanchangElement>? elements) {
    final settings = context.read<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subheadingColor = isDark ? Theme.of(context).primaryColor : const Color(0xFF8B0000);
    
    List<Widget> content = [];
    if (elements == null || elements.isEmpty) {
      content.add(Text(settings.getString('unknown'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, height: 1.2)));
    } else {
      for (int i = 0; i < elements.length; i++) {
        final el = elements[i];
        if (i > 0) {
           content.add(const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(height: 1, thickness: 0.5)));
        }
        
        // Name logic: try to localize if it is tithi, otherwise just name
        String name = el.name ?? settings.getString('unknown');
        if (el.number != null && title == settings.getString('tithi')) {
           name = PanchangUtils.getLocalizedTithiName(context, el.number!);
        }

        content.add(Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, height: 1.2), textAlign: TextAlign.center));
        
        if (el.endTime != null) {
           content.add(Text('${settings.getString('ends')}: ${PanchangUtils.formatTime(el.endTime)}', 
             style: Theme.of(context).textTheme.bodySmall?.copyWith(color: subheadingColor)));
        }
      }
    }

    return VedicCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...content,
        ],
      ),
    );
  }

  Widget _buildSunMoonCard(BuildContext context, dynamic panchang) {
    final settings = context.read<SettingsProvider>();
    return VedicCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeItem(context, Icons.wb_sunny, settings.getString('sunrise'), panchang.sunrise),
              _buildTimeItem(context, Icons.wb_twilight, settings.getString('sunset'), panchang.sunset),
            ],
          ),
          const Divider(height: 24, color: Color(0x40FFD700)), // Subtle gold divider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeItem(context, Icons.nightlight_round, settings.getString('moonrise'), panchang.moonrise),
              _buildTimeItem(context, Icons.bedtime, settings.getString('moonset'), panchang.moonset),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeItem(BuildContext context, IconData icon, String label, String? time) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subheadingColor = isDark ? Theme.of(context).primaryColor.withOpacity(0.9) : const Color(0xFF8B0000);
    
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: subheadingColor)),
        Text(time ?? '--:--', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, dynamic panchang) {
    final settings = context.read<SettingsProvider>();
    // Parse date if available
    String dateStr = 'Today';
    if (panchang.dateTime != null) {
      try {
        final dt = DateTime.parse(panchang.dateTime!);
        dateStr = DateFormat('EEE, dd MMM yyyy').format(dt);
      } catch (e) {
        dateStr = panchang.dateTime!;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          settings.getString('todays_panchang'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dateStr,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showLocationDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 16, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(panchang.placeName ?? settings.getString('unknown'), style: Theme.of(context).textTheme.bodyLarge?.copyWith(decoration: TextDecoration.underline)),
                const SizedBox(width: 4),
                Icon(Icons.edit, size: 14, color: Theme.of(context).primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLocationDialog(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    final placeController = TextEditingController();
    final latController = TextEditingController();
    final lngController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(settings.getString('change_location')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<PanchangProvider>().useCurrentLocation();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.my_location),
                label: Text(settings.getString('use_current_location')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Place Name with Search Icon
            TextField(
              controller: placeController,
              readOnly: true,
              onTap: () async {
                final city = await showSearch(
                  context: context,
                  delegate: LocationSearchDelegate(),
                );
                if (city != null) {
                  placeController.text = city.name;
                  latController.text = city.latitude.toString();
                  lngController.text = city.longitude.toString();
                }
              },
              decoration: InputDecoration(
                labelText: settings.getString('place_name'),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            TextField(
              controller: latController,
              decoration: InputDecoration(labelText: settings.getString('latitude')),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: lngController,
              decoration: InputDecoration(labelText: settings.getString('longitude')),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(settings.getString('cancel')),
          ),
          TextButton(
            onPressed: () {
              if (latController.text.isNotEmpty && lngController.text.isNotEmpty) {
                context.read<PanchangProvider>().setManualLocation(
                  double.parse(latController.text),
                  double.parse(lngController.text),
                  placeController.text,
                );
                Navigator.pop(context);
              }
            },
            child: Text(settings.getString('set')),
          ),
        ],
      ),
    );
  }
}


