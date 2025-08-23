import 'package:fileco/components/file_browser/widgets/appbar.dart';
import 'package:flutter/material.dart';

import '../widgets/detail_screen.dart';
 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  
  final List<Map<String, dynamic>> items = const [
    {"title": "Main storage", "subtitle": "125 GB / 128 GB", "icon": Icons.sd_storage},
    {"title": "Downloads", "subtitle": "1.9 GB (394)", "icon": Icons.download},
    {"title": "Storage Analy...", "subtitle": "97% used", "icon": Icons.pie_chart},
    {"title": "Images", "subtitle": "1.3 GB (2871)", "icon": Icons.image},
    {"title": "Audio", "subtitle": "4.9 GB (659)", "icon": Icons.music_note},
    {"title": "Videos", "subtitle": "34.7 GB (321)", "icon": Icons.videocam},
    {"title": "Documents", "subtitle": "1.8 GB (913)", "icon": Icons.description},
    {"title": "Apps", "subtitle": "18.2 GB (118)", "icon": Icons.android},
    {"title": "New files", "subtitle": "3.3 GB (183)", "icon": Icons.access_time},
    {"title": "Cloud", "subtitle": "", "icon": Icons.cloud},
    {"title": "Remote", "subtitle": "", "icon": Icons.computer},
    {"title": "Access from n...", "subtitle": "", "icon": Icons.devices},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(title: "Fileco"),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(title: item["title"]),
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(item["icon"], size: 30, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(item["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  if (item["subtitle"].toString().isNotEmpty)
                    Text(item["subtitle"],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
