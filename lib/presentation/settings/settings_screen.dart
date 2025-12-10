import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/vedic_background.dart';
import '../widgets/vedic_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLanguage;
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _selectedLanguage = settings.language;
    _selectedThemeMode = settings.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text(settings.getString('settings'))),
      body: VedicBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              VedicCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(settings.getString('language'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedLanguage,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: 'en', child: Text('English')),
                              DropdownMenuItem(value: 'hi', child: Text('Hindi (हिंदी)')),
                              DropdownMenuItem(value: 'te', child: Text('Telugu (తెలుగు)')),
                              DropdownMenuItem(value: 'sa', child: Text('Sanskrit (संस्कृतम्)')),
                              DropdownMenuItem(value: 'ta', child: Text('Tamil (தமிழ்)')),
                              DropdownMenuItem(value: 'kn', child: Text('Kannada (ಕನ್ನಡ)')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedLanguage = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(settings.getString('theme'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ThemeMode>(
                            value: _selectedThemeMode,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(value: ThemeMode.light, child: Text(settings.getString('theme_light'))),
                              DropdownMenuItem(value: ThemeMode.dark, child: Text(settings.getString('theme_dark'))),
                              DropdownMenuItem(value: ThemeMode.system, child: Text(settings.getString('theme_system'))),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedThemeMode = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<SettingsProvider>().setLanguage(_selectedLanguage);
                            context.read<SettingsProvider>().setThemeMode(_selectedThemeMode);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(settings.getString('save')),
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
}
