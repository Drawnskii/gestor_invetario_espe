import 'package:flutter/material.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    // Verifica si el tema del sistema es oscuro
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: SwitchListTile(
          title: Text('Modo Obscuro'),
          subtitle: Text('Activa o desactiva el modo obscuro'),
          value: controller.themeMode == ThemeMode.dark || 
                (controller.themeMode == ThemeMode.system && isDarkMode),
          onChanged: (bool value) {
            // Actualiza el themeMode basado en el valor del Switch
            controller.updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);

            final cardColor = Theme.of(context).cardColor;
            final primaryColor = Theme.of(context).primaryColor;

            // Imprimir colores en la consola
            debugPrint('Card Color: $cardColor');
            debugPrint('Primary Color: $primaryColor');
          },
        ),
      ),
    );
  }
}
