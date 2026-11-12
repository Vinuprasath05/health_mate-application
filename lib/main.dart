import 'package:flutter/material.dart';
import 'Controllers/health_controller.dart';
import 'Screen/Dashboard.dart';
import 'Screen/List.dart';
import 'Screen/Search.dart';
import 'Screen/Add_Details.dart';
import 'package:provider/provider.dart';
import'provider/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const HealthMateApp(),
    ),

    
    );
}

class HealthMateApp extends StatelessWidget {
  const HealthMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthMate',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2878E5),
          primary: const Color(0xFF2878E5),
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F8FC),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF4F7FB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int selectedIndex = 0;

  final pages = const [
    DashboardScreen(),
    HealthListScreen(),
    SearchScreen(),
  ];

  Future<void> _openAddRecord() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddDetailsScreen()),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: selectedIndex, children: pages)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddRecord,
        backgroundColor: const Color(0xFF2878E5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add record'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_month_rounded), label: 'Records'),
          NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),
        ],
      ),
    );
  }
}
