import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'views/auth/auth_form.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'views/objects/grid_objects.dart';
import 'views/scanner.dart';
import 'views/objects/object_registry.dart';
import 'models/todo.dart';

/// Configuración de la aplicación principal.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // Inglés
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          initialRoute: AuthForm.routeName, // Pantalla inicial
          routes: {
            AuthForm.routeName: (context) => const AuthForm(),
            '/home': (context) => const MainScreen(), // Pantalla principal
            SettingsView.routeName: (context) =>
                SettingsView(controller: settingsController),
          },
        );
      },
    );
  }
}

/// Implementación de MainScreen
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<String> _title = [
    'Objetos Registrados',
    'Registrar un Objeto',
    'Escanear'
  ];

  final List<Widget> _views = [
    GridObjects(
      todos: List.generate(
        20,
        (i) => Todo(
          'Todo $i',
          'Descripción del objeto Todo $i',
        ),
      ),
    ),
    const ObjectRegistry(),
    Scanner(
      todos: List.generate(
        20,
        (i) => Todo(
          'Todo $i',
          'Descripción del objeto Todo $i',
        ),
      ),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title[_selectedIndex]),
      ),
      body: _views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Registrar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_rounded),
            label: 'Escanear',
          ),
        ],
      ),
    );
  }
}
