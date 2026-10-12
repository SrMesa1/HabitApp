import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const AppHabitos());

class AppHabitos extends StatelessWidget {
  const AppHabitos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const PantallaInicio(),
    );
  }
}
