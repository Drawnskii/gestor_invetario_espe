import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'views/auth/auth_form.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

import 'views/goods/goods_list.dart';
import 'views/scanner.dart';

import 'services/auth/login_service.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.orange,
          ),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case AuthForm.routeName:
                    return AuthForm();
                  default:
                    return const MainScreen();
                }
              },
            );
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _views = [
    GoodsList(),
    Scanner()
  ];

  void _destinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0), // Padding solo a la izquierda
          child: SvgPicture.asset(
            'assets/images/logo_espe.svg', // Asegúrate de que el archivo esté en assets altura
            width: 100,
            height: 100,
          ),
        ),
        title: Text(
          'MiAcopio',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(Icons.settings),
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título del Drawer
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Gestión de perfil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // FUTUREBUILDER PARA VERIFICAR SI EL USUARIO ESTÁ AUTENTICADO
            FutureBuilder<bool>(
              future: LoginService().isLoggedIn(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == false) {
                  // Usuario NO autenticado: Mostrar opción de login
                  return ListTile(
                    leading: const Icon(Icons.login_rounded),
                    title: const Text('Iniciar Sesión o Registrarse'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.restorablePushNamed(context, AuthForm.routeName);
                    },
                  );
                } else {
                  return SizedBox.shrink(); // No mostrar nada si el usuario está logueado
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
            Divider(),
            // Cerrar Sesión (Solo se muestra si está autenticado)
            FutureBuilder<bool>(
              future: LoginService().isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return ListTile(
                    leading: Icon(Icons.logout_rounded, size: 20),
                    title: Text(
                      'Cerrar Sesión',
                      style: TextStyle(fontSize: 14),
                    ),
                    onTap: () async {
                      await LoginService().logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                  );
                } else {
                  return SizedBox.shrink(); // No mostrar si no está logueado
                }
              },
            ),
          ],
        ),
      ),
      body: _views[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _destinationSelected,
        destinations: const <Widget> [
          NavigationDestination(icon: Icon(Icons.inventory_2_rounded), label: 'Inventario'),
          NavigationDestination(icon: Icon(Icons.qr_code_rounded), label: 'Scanner')
        ],
      ),
    );
  }
}