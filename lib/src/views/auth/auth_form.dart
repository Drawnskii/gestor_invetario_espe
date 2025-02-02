import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  static const routeName = '/auth';

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  int _selectedIndex = 0; // Para mantener el índice seleccionado

  // Función para actualizar el título en función de la pestaña seleccionada
  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Ingresa con tu cuenta';
      case 1:
        return 'Crea una nueva cuenta';
      default:
        return 'Autentificación';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true, // Para centrar el texto
          title: Text(
            _getAppBarTitle(), // Título dinámico
            style: TextStyle(
              fontWeight: FontWeight.w900, // Peso alto para el texto
            ),
          ),
        ),
        body: TabBarView(
          children: const <Widget>[
            Center(child: Login()),
            Center(child: Register()),
          ],
        ),
        bottomNavigationBar: TabBar(

          onTap: (index) {
            setState(() {
              _selectedIndex = index; // Actualiza el índice seleccionado
            });
          },
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.login_rounded),
              text: 'Inicia Sesión',
            ),
            Tab(
              icon: Icon(Icons.app_registration_outlined),
              text: 'Regístrate',
            ),
          ],
        ),
      ),
    );
  }
}
