import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/file_service.dart';
 

class FileManagerProvider extends ChangeNotifier {
  final FileService _fileService = FileService();
  
  List<FileSystemEntity> _files = [];
  List<FileSystemEntity> _filteredFiles = [];
  List<String> _recentFiles = [];
  List<String> _favoriteFiles = [];
  String _currentPath = '';
  String _searchQuery = '';
  bool _isLoading = false;
  FileAccessMethod _currentAccessMethod = FileAccessMethod.directoryBrowser;

  // Getters
  List<FileSystemEntity> get files => _filteredFiles;
  List<String> get recentFiles => _recentFiles;
  List<String> get favoriteFiles => _favoriteFiles;
  String get currentPath => _currentPath;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  FileAccessMethod get currentAccessMethod => _currentAccessMethod;

  FileManagerProvider() {
    _loadPreferences();
    _loadInitialDirectory();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _recentFiles = prefs.getStringList('recent_files') ?? [];
    _favoriteFiles = prefs.getStringList('favorite_files') ?? [];
    notifyListeners();
  }

  Future<void> _saveRecentFiles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recent_files', _recentFiles);
  }

  Future<void> _saveFavoriteFiles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_files', _favoriteFiles);
  }

  Future<void> _loadInitialDirectory() async {
    _setLoading(true);
    try {
      final files = await _fileService.getDocumentsDirectoryFiles();
      _files = files;
      _filteredFiles = files;
      _currentPath = await _fileService.getDocumentsDirectoryPath();
    } catch (e) {
      debugPrint('Error loading initial directory: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadDirectory(String path) async {
    _setLoading(true);
    try {
      final files = await _fileService.getDirectoryFiles(path);
      _files = files;
      _currentPath = path;
      _applySearch(_searchQuery);
    } catch (e) {
      debugPrint('Error loading directory: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickFiles() async {
    _setLoading(true);
    try {
      final files = await _fileService.pickFiles();
      if (files.isNotEmpty) {
        _files = files.map((path) => File(path)).cast<FileSystemEntity>().toList();
        _currentPath = 'Selected Files';
        _applySearch(_searchQuery);
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
    } finally {
      _setLoading(false);
    }
  }

  void setAccessMethod(FileAccessMethod method) {
    _currentAccessMethod = method;
    notifyListeners();
    
    switch (method) {
      case FileAccessMethod.filePicker:
        pickFiles();
        break;
      case FileAccessMethod.directoryBrowser:
        _loadInitialDirectory();
        break;
    }
  }

  void searchFiles(String query) {
    _searchQuery = query;
    _applySearch(query);
  }

  void _applySearch(String query) {
    if (query.isEmpty) {
      _filteredFiles = List.from(_files);
    } else {
      _filteredFiles = _files.where((file) {
        final fileName = file.path.split('/').last.toLowerCase();
        return fileName.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> openFile(String filePath) async {
    try {
      await _fileService.openFile(filePath);
      await _addToRecentFiles(filePath);
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
  }

  Future<void> _addToRecentFiles(String filePath) async {
    _recentFiles.remove(filePath);
    _recentFiles.insert(0, filePath);
    if (_recentFiles.length > 10) {
      _recentFiles = _recentFiles.take(10).toList();
    }
    await _saveRecentFiles();
    notifyListeners();
  }

  Future<void> toggleFavorite(String filePath) async {
    if (_favoriteFiles.contains(filePath)) {
      _favoriteFiles.remove(filePath);
    } else {
      _favoriteFiles.add(filePath);
    }
    await _saveFavoriteFiles();
    notifyListeners();
  }

  bool isFavorite(String filePath) {
    return _favoriteFiles.contains(filePath);
  }

  Future<void> refreshCurrentDirectory() async {
    if (_currentPath.isNotEmpty && _currentPath != 'Selected Files') {
      await loadDirectory(_currentPath);
    } else {
      await _loadInitialDirectory();
    }
  }
}

enum FileAccessMethod { directoryBrowser, filePicker }