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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Ingresa o Registra una Cuenta',
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
