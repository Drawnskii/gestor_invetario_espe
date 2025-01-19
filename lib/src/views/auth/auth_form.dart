import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inicia Sesión o Regístrate'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.login_rounded),
              ),
              Tab(
                icon: Icon(Icons.app_registration_outlined),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget> [
            Center(child: Login()),
            Center(child: Register())
          ]
        ),
      )
    );
  }
}