/*
TODO: implementing file access methods including sharedPreferences, 
TODO: use lazy loading for large files to avoid memory issues
TODO: use package like file_picker, path_provider,file_manager, sharedPreferences etc.
TODO: if necessary implement provider for state management
*/
import 'dart:io';
import 'package:fileco/components/file_browser/widgets/dialogs.dart';
import 'package:fileco/components/file_browser/widgets/file_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/file_manager_provider.dart';
import 'file_service.dart';

class FileAccess extends StatefulWidget {
  const FileAccess({super.key});

  @override
  State<FileAccess> createState() => _FileAccessState();
}

class _FileAccessState extends State<FileAccess> {
  final FileService _fileService = FileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<FileManagerProvider>().refreshCurrentDirectory(),
          ),
          PopupMenuButton<FileAccessMethod>(
            onSelected: (method) => context.read<FileManagerProvider>().setAccessMethod(method),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FileAccessMethod.directoryBrowser,
                child: Row(
                  children: [
                    Icon(Icons.folder),
                    SizedBox(width: 8),
                    Text('Directory Browser'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: FileAccessMethod.filePicker,
                child: Row(
                  children: [
                    Icon(Icons.file_copy),
                    SizedBox(width: 8),
                    Text('File Picker'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchBarWidget(),
          _buildCurrentPath(),
          Expanded(child: _buildFileList()),
        ],
      ),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildCurrentPath() {
    return Consumer<FileManagerProvider>(
      builder: (context, provider, child) {
        if (provider.currentPath.isEmpty) return const SizedBox.shrink();
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Text(
            provider.currentPath,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget _buildFileList() {
    return Consumer<FileManagerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.files.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No files found', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

        return LazyLoadingListView(files: provider.files);
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'File Manager',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Recent Files'),
            onTap: () => _showRecentFiles(),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () => _showFavoriteFiles(),
          ),
        ],
      ),
    );
  }

  void _showRecentFiles() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => const RecentFilesDialog(),
    );
  }

  void _showFavoriteFiles() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => const FavoriteFilesDialog(),
    );
  }
}

// widgets/lazy_loading_list_view.dart
class LazyLoadingListView extends StatelessWidget {
  final List<FileSystemEntity> files;
  
  const LazyLoadingListView({
    super.key,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        return FileTile(file: files[index]);
      },
    );
  }
}

// widgets/search_bar.dart
class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search files...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<FileManagerProvider>().searchFiles('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (query) {
          context.read<FileManagerProvider>().searchFiles(query);
        },
      ),
    );
  }
}


 

class FavoriteFilesDialog extends StatelessWidget {
  const FavoriteFilesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FileManagerProvider>(
      builder: (context, provider, child) {
        return AlertDialog(
          title: const Text('Favorite Files'),
          content: SizedBox(
            width: double.maxFinite,
            child: provider.favoriteFiles.isEmpty
                ? const Text('No favorite files')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.favoriteFiles.length,
                    itemBuilder: (context, index) {
                      final filePath = provider.favoriteFiles[index];
                      final fileName = filePath.split('/').last;
                      
                      return ListTile(
                        title: Text(fileName),
                        subtitle: Text(filePath),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => provider.toggleFavorite(filePath),
                        ),
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