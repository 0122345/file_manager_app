import 'dart:typed_data';
import 'package:fileco/models/folder.dart';
import 'package:fileco/models/file.dart';

class Storageservice {
  final Map<String, Folder> _folders = {};
  final Map<int, File> _files = {};
  final Map<int, Uint8List> _fileData = {};
  int _nextFileId = 1;

  //TODO: createFolder()
  Folder createFolder({
    required String name,
    required String owner,
    String? icon,
    String? id,
  }) {
    final folderId = id ?? DateTime.now().millisecondsSinceEpoch.toString();

    if (_folders.containsKey(folderId)) {
      throw Exception('Folder with id $folderId already exists');
    }

    final folder = Folder(
      name: name,
      owner: owner,
      createdAt: DateTime.now().toIso8601String(),
      icon: icon,
      id: folderId,
    );

    _folders[folderId] = folder;
    return folder;
  }

  //TODO: saveFile()

  File saveFile({
    required String name,
    required String owner,
    required String type,
    required Uint8List content,
    String? icon,
  }) {
    final file = File(
      id: _nextFileId++,
      name: name,
      owner: owner,
      type: type,
      createdAt: DateTime.now().toIso8601String(),
      icon: icon,
      size: content.length,
    );

    _files[file.id] = file;
    _fileData[file.id] = content;

    return file;
  }

  //TODO: readFile() by file Id

  Uint8List? readFile(int fileId) {
    if (!_files.containsKey(fileId)) {
      throw Exception('File with id $fileId does not exist');
    }
    return _fileData[fileId];
  }

  //TODO: readFile() metadata by fileID
  File? getFileMetadata(int fileId) {
    return _files[fileId];
  }

  //TODO: deleteFile() by file Id

  bool deleteFile(int fileId) {
    if (!_files.containsKey(fileId)) {
      return false;
    }
    _files.remove(fileId);
    _fileData.remove(fileId);
    return true;
  }

  //TODO: deleteFolder() by Id

  bool deleteFolder(String folderId) {
    if (!_folders.containsKey(folderId)) {
      return false;
    }

    _folders.remove(folderId);
    return true;
  }

  //TODO: TotalSize()

  int totalSize() {
    return _files.values
        .map((file) => file.size ?? 0)
        .fold(0, (sum, size) => sum + size);
  }

  //TODO: get all Folders
  List<Folder> getAllFolders() {
    return _folders.values.toList();
  }

  /// Gets all files
  List<File> getAllFiles() {
    return _files.values.toList();
  }

  /// Gets folder by ID
  Folder? getFolder(String folderId) {
    return _folders[folderId];
  }

  /// Gets files by owner
  List<File> getFilesByOwner(String owner) {
    return _files.values.where((file) => file.owner == owner).toList();
  }

  /// Gets folders by owner
  List<Folder> getFoldersByOwner(String owner) {
    return _folders.values.where((folder) => folder.owner == owner).toList();
  }

  /// Gets files by type
  List<File> getFilesByType(String type) {
    return _files.values.where((file) => file.type == type).toList();
  }

  //clear storage
  void clearAll() {
    _folders.clear();
    _files.clear();
    _fileData.clear();
    _nextFileId = 1;
  }

  //Statistics

  Map<String, dynamic> getStorageStats() {
    return {
      'totalFolders': _folders.length,
      'totalFiles': _files.length,
      'totalSizeBytes': totalSize(),
      'averageFileSize': _files.isEmpty ? 0 : totalSize() / _files.length,
      'owners': _files.values.map((f) => f.owner).toSet().length,
    };
  }
}
