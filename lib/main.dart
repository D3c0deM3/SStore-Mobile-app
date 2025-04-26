import 'package:flutter/material.dart';
import 'package:sstore_app/screens/login_register_screen.dart';

void main() {
  runApp(SStoreApp());
}

class SStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginRegisterScreen(), // <- this points to your custom screen
    );
  }
}
