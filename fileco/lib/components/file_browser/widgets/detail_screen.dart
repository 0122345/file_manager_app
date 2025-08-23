import 'package:flutter/material.dart';
import 'appbar.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  const DetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(title: title),
      body: Center(
        child: Text('Detail Screen for $title',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
