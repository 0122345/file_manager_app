import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/file_manager_provider.dart';

class RecentFilesDialog extends StatelessWidget {
  const RecentFilesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FileManagerProvider>(
      builder: (context, provider, child) {
        return AlertDialog(
          title: const Text('Recent Files'),
          content: SizedBox(
            width: double.maxFinite,
            child: provider.recentFiles.isEmpty
                ? const Text('No recent files')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.recentFiles.length,
                    itemBuilder: (context, index) {
                      final filePath = provider.recentFiles[index];
                      final fileName = filePath.split('/').last;
                      
                      return ListTile(
                        title: Text(fileName),
                        subtitle: Text(filePath),
                        onTap: () {
                          Navigator.pop(context);
                          provider.openFile(filePath);
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
