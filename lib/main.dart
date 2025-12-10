import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'data/api_client.dart';
import 'data/repositories/panchang_repository.dart';
import 'data/repositories/chart_repository.dart';
import 'presentation/providers/panchang_provider.dart';
import 'presentation/providers/chart_provider.dart';
import 'data/repositories/dasa_repository.dart';
import 'data/repositories/muhurta_repository.dart';
import 'presentation/providers/dasa_provider.dart';
import 'presentation/providers/muhurta_provider.dart';
import 'presentation/splash_screen.dart';
import 'data/repositories/compatibility_repository.dart';
import 'presentation/providers/compatibility_provider.dart';

import 'presentation/providers/settings_provider.dart';

void main() {
  print("PURNIMA_DEBUG: App Starting...");
  runApp(const PurnimaApp());
}

class PurnimaApp extends StatelessWidget {
  const PurnimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        Provider(create: (_) => ApiClient()),
        ProxyProvider<ApiClient, PanchangRepository>(
          update: (_, client, __) => PanchangRepository(client),
        ),
        ProxyProvider<ApiClient, ChartRepository>(
          update: (_, client, __) => ChartRepository(client),
        ),
        ChangeNotifierProxyProvider2<PanchangRepository, SettingsProvider, PanchangProvider>(
          create: (context) => PanchangProvider(
            context.read<PanchangRepository>(), 
            context.read<SettingsProvider>()
          ),
          update: (_, repo, settings, prev) => prev!..update(repo, settings),
        ),
        ChangeNotifierProxyProvider2<ChartRepository, SettingsProvider, ChartProvider>(
          create: (context) => ChartProvider(context.read<ChartRepository>()),
          update: (_, repo, settings, prev) => prev!..update(repo, settings),
        ),
        ProxyProvider<ApiClient, DasaRepository>(
          update: (_, client, __) => DasaRepository(client),
        ),
        ProxyProvider<ApiClient, MuhurtaRepository>(
          update: (_, client, __) => MuhurtaRepository(client),
        ),
        ChangeNotifierProxyProvider2<DasaRepository, SettingsProvider, DasaProvider>(
          create: (context) => DasaProvider(
            context.read<DasaRepository>(),
            context.read<SettingsProvider>()
          ),
          update: (_, repo, settings, prev) => prev!..update(repo, settings),
        ),
        ChangeNotifierProxyProvider2<MuhurtaRepository, SettingsProvider, MuhurtaProvider>(
          create: (context) => MuhurtaProvider(
            context.read<MuhurtaRepository>(),
            context.read<SettingsProvider>()
          ),
          update: (_, repo, settings, prev) => prev!..update(repo, settings),
        ),
        ProxyProvider<ApiClient, CompatibilityRepository>(
          update: (_, client, __) => CompatibilityRepository(client),
        ),
        ChangeNotifierProvider<CompatibilityProvider>(
           create: (context) => CompatibilityProvider(
             context.read<CompatibilityRepository>(),
           ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Purnima',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
