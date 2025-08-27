import 'dart:typed_data';
import 'dart:convert';
import 'storageservic.dart';

void main() {
  final storage = Storageservice();

  // Example usage of the storage service
  
  // 1. Create folders
  print('=== Creating Folders ===');
  final documentsFolder = storage.createFolder(
    name: 'Documents',
    owner: 'user123',
    icon: 'folder',
  );
  print('Created folder: ${documentsFolder.name} with ID: ${documentsFolder.id}');

  final imagesFolder = storage.createFolder(
    name: 'Images',
    owner: 'user123',
    icon: 'image',
    id: 'custom-images-id',
  );
  print('Created folder: ${imagesFolder.name} with ID: ${imagesFolder.id}');

  // 2. Save files
  print('\n=== Saving Files ===');
  final textContent = Uint8List.fromList(utf8.encode('Hello, World!'));
  final textFile = storage.saveFile(
    name: 'hello.txt',
    owner: 'user123',
    type: 'text/plain',
    content: textContent,
    icon: 'txt',
  );
  print('Saved file: ${textFile.name} (${textFile.size} bytes)');

  final imageContent = Uint8List.fromList(List.filled(1024, 255)); // Dummy image data
  final imageFile = storage.saveFile(
    name: 'photo.jpg',
    owner: 'user456',
    type: 'image/jpeg',
    content: imageContent,
  );
  print('Saved file: ${imageFile.name} (${imageFile.size} bytes)');

  // 3. Read file
  print('\n=== Reading Files ===');
  final readContent = storage.readFile(textFile.id);
  if (readContent != null) {
    final contentString = utf8.decode(readContent);
    print('Read content from ${textFile.name}: "$contentString"');
  }

  // 4. Get file metadata
  final fileMetadata = storage.getFileMetadata(imageFile.id);
  print('Image file metadata: ${fileMetadata?.name}, type: ${fileMetadata?.type}');

  // 5. Calculate total size
  print('\n=== Storage Statistics ===');
  final totalSizeBytes = storage.totalSize();
  print('Total storage size: $totalSizeBytes bytes');

  final stats = storage.getStorageStats();
  print('Storage stats: $stats');

  // 6. List all items
  print('\n=== Listing Items ===');
  final allFolders = storage.getAllFolders();
  print('All folders:');
  for (final folder in allFolders) {
    print('  - ${folder.name} (${folder.owner}) created: ${folder.createdAt}');
  }

  final allFiles = storage.getAllFiles();
  print('All files:');
  for (final file in allFiles) {
    print('  - ${file.name} (${file.type}) ${file.size} bytes, owner: ${file.owner}');
  }

  // 7. Filter by owner
  print('\n=== Filtering by Owner ===');
  final user123Files = storage.getFilesByOwner('user123');
  print('Files owned by user123: ${user123Files.map((f) => f.name).join(', ')}');

  final user123Folders = storage.getFoldersByOwner('user123');
  print('Folders owned by user123: ${user123Folders.map((f) => f.name).join(', ')}');

  // 8. Delete operations
  print('\n=== Deletion Operations ===');
  final deleted = storage.deleteFile(textFile.id);
  print('Deleted text file: $deleted');

  final folderDeleted = storage.deleteFolder(documentsFolder.id!);
  print('Deleted documents folder: $folderDeleted');

  // 9. Final statistics
  print('\n=== Final Statistics ===');
  print('Total size after deletions: ${storage.totalSize()} bytes');
  print('Remaining files: ${storage.getAllFiles().length}');
  print('Remaining folders: ${storage.getAllFolders().length}');
}