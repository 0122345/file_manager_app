import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

Widget _buildProfile(dynamic String name, dynamic String image) {
 return Container(
  width: double.infinity,
  height: double.infinity,
  decoration: BoxDecoration(),
  child: Column(),
 );
}

Widget _buildCards(){}
