import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:app/presentation/home_screen.dart';
import 'package:app/presentation/providers/panchang_provider.dart';
import 'package:app/presentation/providers/settings_provider.dart';
import 'package:app/data/models/panchang_model.dart';
import 'package:app/data/repositories/panchang_repository.dart';
import 'package:app/presentation/providers/muhurta_provider.dart';
import 'package:app/data/models/muhurta_model.dart';


// Mock implementations
class MockPanchangProvider extends ChangeNotifier implements PanchangProvider {
  PanchangResult? _panchang;
  bool _isLoading = false;
  String? _error;

  @override
  PanchangResult? get panchang => _panchang;
  
  @override
  bool get isLoading => _isLoading;
  
  @override
  String? get error => _error;

  int loadCallCount = 0;

  @override
  Future<void> loadPanchang() async {
    loadCallCount++;
    return Future.value();
  }
  
  void setPanchang(PanchangResult p) {
    _panchang = p;
    notifyListeners();
  }

  // Handle other members required by interface
  @override
  dynamic noSuchMethod(Invocation invocation) {
    print("Invocation: ${invocation.memberName}");
     return super.noSuchMethod(invocation);
  }
}

class MockSettingsProvider extends ChangeNotifier implements SettingsProvider {
  @override
  String get language => 'en';
  
  @override
  String getString(String key) => key;
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockMuhurtaProvider extends ChangeNotifier implements MuhurtaProvider {
  MuhurtaResult? _muhurta;
  bool _isLoading = false;
  String? _error;

  @override
  MuhurtaResult? get muhurta => _muhurta;
  @override
  bool get isLoading => _isLoading;
  @override
  String? get error => _error;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}



void main() {
  testWidgets('PanchangView shows RefreshIndicator when data is present and triggers refresh', (WidgetTester tester) async {
    await initializeDateFormatting();
    
    final mockPanchangProvider = MockPanchangProvider();
    final mockSettingsProvider = MockSettingsProvider();
    final mockMuhurtaProvider = MockMuhurtaProvider();

    // Create dummy data
    final dummyPanchang = PanchangResult(
       tithi: [],
       vara: null,
       nakshatra: [],
       yoga: [],
       karana: [],
       dateTime: "2023-10-10T10:00:00",
       placeName: "Test City"
    );
    mockPanchangProvider.setPanchang(dummyPanchang);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<PanchangProvider>.value(value: mockPanchangProvider),
          ChangeNotifierProvider<SettingsProvider>.value(value: mockSettingsProvider),
          ChangeNotifierProvider<MuhurtaProvider>.value(value: mockMuhurtaProvider),
        ],
        child: MaterialApp(
          home: Scaffold(body: const PanchangView()),
        ),
      ),
    );



    expect(find.byType(RefreshIndicator), findsOneWidget);
    
    // Verify SingleChildScrollView is descendant
    expect(find.descendant(of: find.byType(RefreshIndicator), matching: find.byType(SingleChildScrollView)), findsOneWidget);

    // Trigger refresh
    await tester.fling(find.byType(SingleChildScrollView), const Offset(0, 300), 1000);
    await tester.pump(); // Start animation
    await tester.pump(const Duration(seconds: 1)); // Wait for indicator to appear
    await tester.pump(const Duration(seconds: 1)); // Wait for refresh to complete (it's immediate in mock but indicator has animation)
    await tester.pumpAndSettle();
    
    // Expect loadPanchang called
    expect(mockPanchangProvider.loadCallCount, 1);
  });
}
