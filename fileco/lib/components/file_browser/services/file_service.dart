import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mime/mime.dart';

class FileService {
  static final FileService _instance = FileService._internal();
  factory FileService() => _instance;
  FileService._internal();

  Future<bool> _requestPermissions() async {
    final status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  Future<String> getDocumentsDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<FileSystemEntity>> getDocumentsDirectoryFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    return _getDirectoryContents(directory.path);
  }

  Future<List<FileSystemEntity>> getDirectoryFiles(String path) async {
    return _getDirectoryContents(path);
  }

  Future<List<FileSystemEntity>> _getDirectoryContents(String path) async {
    try {
      final directory = Directory(path);
      if (!await directory.exists()) {
        return [];
      }
      final contents = await directory.list().toList();

      contents.sort((a, b) {
        if (a is Directory && b is File) return -1;
        if (a is File && b is Directory) return 1;
        return a.path.toLowerCase().compareTo(b.path.toLowerCase());
      });

      return contents;
    } catch (e) {
      print("Error accessing directory: $e");
      return [];
    }
  }

  Future<List<String>> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        return result.paths
            .where((path) => path != null)
            .cast<String>()
            .toList();
      }
      return [];
    } catch (e) {
      print('Error picking files: $e');
      return [];
    }
  }

  Future<void> openFile(String filePath) async {
    try {
      await OpenFilex.open(filePath);
    } catch (e) {
      print("Error in opening file: $e");
      throw Exception("Could not open file: ${e.toString()}");
    }
  }

  String getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  String? getFileMimeType(String filePath) {
    return lookupMimeType(filePath);
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<Map<String, dynamic>> getFileInfo(String filePath) async {
    try {
      final file = File(filePath);
      final stat = await file.stat();
      
      return {
        'name': filePath.split('/').last,
        'path': filePath,
        'size': stat.size,
        'formattedSize': formatFileSize(stat.size),
        'modified': stat.modified,
        'extension': getFileExtension(filePath),
        'mimeType': getFileMimeType(filePath),
        'isDirectory': stat.type == FileSystemEntityType.directory,
      };
    } catch (e) {
      print('Error getting file info: $e');
      return {};
    }
  }

}

