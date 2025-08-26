import 'dart:io';

import 'package:fileco/components/file_browser/provider/file_manager_provider.dart';
import 'package:fileco/components/file_browser/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileTile extends StatelessWidget {
  final FileSystemEntity file;

  const FileTile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final fileName = file.path.split('/').last;
    final isDirectory = file is Directory;

    return Consumer<FileManagerProvider>(
      builder: (context, provider, child) {
        final isFavorite = provider.isFavorite(file.path);
        
        return ListTile(
          leading: Icon(
            isDirectory ? Icons.folder : _getFileIcon(fileName),
            color: isDirectory ? Colors.blue : Colors.grey[600],
            size: 32,
          ),
          title: Text(
            fileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: FutureBuilder<Map<String, dynamic>>(
            future: FileService().getFileInfo(file.path),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final info = snapshot.data!;
                return Text('${info['formattedSize']} • ${_formatDate(info['modified'])}');
              }
              return const Text('Loading...');
            },
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () => provider.toggleFavorite(file.path),
              ),
              if (!isDirectory)
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () => provider.openFile(file.path),
                ),
            ],
          ),
          onTap: () {
            if (isDirectory) {
              provider.loadDirectory(file.path);
            } else {
              provider.openFile(file.path);
            }
          },
        );
      },
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp3':
      case 'wav':
      case 'flac':
        return Icons.audio_file;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.archive;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
 