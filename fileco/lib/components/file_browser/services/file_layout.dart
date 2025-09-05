// import 'package:flutter/material.dart';
// //import '../../../enum/view.dart';
// import '../../../models/file.dart' as m;
// import '../../../models/folder.dart';

 
// //FIXME: move to enum filecontent here?

// enum View { list, gridsmall, gridLarge, table }

// class FileLayout<T> extends StatefulWidget {
//   const FileLayout({
//     super.key,
//     required this.items,
//     required this.view,
//     required this.nameOf,
//     this.sizeOf,
//     this.modifiedOf,
//     this.iconOf,
//     this.onTap,
//     this.onLongPress,
//     this.padding = const EdgeInsets.all(8),
//     this.gridSpacing = 8,
//     this.gridSmallCrossAxisCount = 3,
//     this.gridLargeCrossAxisCount = 6,
//   });

//   // Convenience factories for built-in models
//   factory FileLayout.forFiles({
//     Key? key,
//     required List<m.File> items,
//     required View view,
//     void Function(m.File item)? onTap,
//     void Function(m.File item)? onLongPress,
//     EdgeInsetsGeometry padding = const EdgeInsets.all(8),
//     double gridSpacing = 8,
//     int gridSmallCrossAxisCount = 3,
//     int gridLargeCrossAxisCount = 6,
//   }) {
//     return FileLayout<m.File>(
//       key: key,
//       items: items,
//       view: view,
//       nameOf: (f) => f.name,
//       sizeOf: (f) => f.size,
//       modifiedOf: (f) => f.createdAtDate,
//       iconOf: (f) => _iconFromType(f.type),
//       onTap: onTap,
//       onLongPress: onLongPress,
//       padding: padding,
//       gridSpacing: gridSpacing,
//       gridSmallCrossAxisCount: gridSmallCrossAxisCount,
//       gridLargeCrossAxisCount: gridLargeCrossAxisCount,
//     );
//   }

//   factory FileLayout.forFolders({
//     Key? key,
//     required List<Folder> items,
//     required View view,
//     void Function(Folder item)? onTap,
//     void Function(Folder item)? onLongPress,
//     EdgeInsetsGeometry padding = const EdgeInsets.all(8),
//     double gridSpacing = 8,
//     int gridSmallCrossAxisCount = 3,
//     int gridLargeCrossAxisCount = 6,
//   }) {
//     return FileLayout<Folder>(
//       key: key,
//       items: items,
//       view: view,
//       nameOf: (f) => f.name,
//       sizeOf: (_) => null,
//       modifiedOf: (f) => f.createdAtDate,
//       iconOf: (_) => Icons.folder,
//       onTap: onTap,
//       onLongPress: onLongPress,
//       padding: padding,
//       gridSpacing: gridSpacing,
//       gridSmallCrossAxisCount: gridSmallCrossAxisCount,
//       gridLargeCrossAxisCount: gridLargeCrossAxisCount,
//     );
//   }

//   // Minimal icon mapping for common file types
//   static IconData _iconFromType(String? type) {
//     final t = (type ?? '').toLowerCase();
//     switch (t) {
//       case 'pdf':
//         return Icons.picture_as_pdf;
//       case 'jpg':
//       case 'jpeg':
//       case 'png':
//       case 'gif':
//         return Icons.image;
//       case 'mp3':
//       case 'wav':
//         return Icons.music_note;
//       case 'mp4':
//       case 'mkv':
//         return Icons.video_library;
//       case 'folder':
//         return Icons.folder;
//       default:
//         return Icons.insert_drive_file;
//     }
//   }

//   // Data
//   final List<T> items;
//   final View view;

//   // Extractors/adapters
//   final String Function(T item) nameOf;
//   final int? Function(T item)? sizeOf; // in bytes
//   final DateTime? Function(T item)? modifiedOf;
//   final IconData? Function(T item)? iconOf;

//   // Interactions
//   final void Function(T item)? onTap;
//   final void Function(T item)? onLongPress;

//   // Layout configuration
//   final EdgeInsetsGeometry padding;
//   final double gridSpacing;
//   final int gridSmallCrossAxisCount;
//   final int gridLargeCrossAxisCount;

//   @override
//   State<FileLayout<T>> createState() => _FileLayoutState<T>();
// }

// class _FileLayoutState<T> extends State<FileLayout<T>> {
//   @override
//   Widget build(BuildContext context) {
//     switch (widget.view) {
//       case View.list:
//         return _buildList();
//       case View.gridsmall:
//         return _buildGrid(crossAxisCount: widget.gridSmallCrossAxisCount, large: false);
//       case View.gridLarge:
//         return _buildGrid(crossAxisCount: widget.gridLargeCrossAxisCount, large: true);
//       case View.table:
//         return _buildTable();
//     }
//   }

//   // List View
//   Widget _buildList() {
//     final items = widget.items;
//     return ListView.separated(
//       padding: widget.padding,
//       itemCount: items.length,
//       separatorBuilder: (_, __) => const Divider(height: 1),
//       itemBuilder: (context, index) {
//         final item = items[index];
//         final icon = widget.iconOf?.call(item) ?? Icons.insert_drive_file;
//         final name = widget.nameOf(item);
//         final size = widget.sizeOf?.call(item);
//         final modified = widget.modifiedOf?.call(item);
//         return ListTile(
//           leading: Icon(icon),
//           title: Text(name, overflow: TextOverflow.ellipsis),
//           subtitle: Row(
//             children: [
//               if (size != null) Text(_formatSize(size)),
//               if (size != null && modified != null)
//                 const Text(' • '),
//               if (modified != null) Text(_formatDate(modified)),
//             ],
//           ),
//           onTap: widget.onTap == null ? null : () => widget.onTap!(item),
//           onLongPress: widget.onLongPress == null ? null : () => widget.onLongPress!(item),
//         );
//       },
//     );
//   }

//   // Grid View (small/large)
//   Widget _buildGrid({required int crossAxisCount, required bool large}) {
//     final items = widget.items;
//     return GridView.builder(
//       padding: widget.padding,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         mainAxisSpacing: widget.gridSpacing,
//         crossAxisSpacing: widget.gridSpacing,
//         childAspectRatio: large ? 0.9 : 1.0,
//       ),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         final icon = widget.iconOf?.call(item) ?? Icons.insert_drive_file;
//         final name = widget.nameOf(item);
//         final size = widget.sizeOf?.call(item);
//         return Card(
//           clipBehavior: Clip.antiAlias,
//           elevation: 0,
//           child: InkWell(
//             onTap: widget.onTap == null ? null : () => widget.onTap!(item),
//             onLongPress: widget.onLongPress == null ? null : () => widget.onLongPress!(item),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(icon, size: large ? 56 : 40),
//                   const SizedBox(height: 8),
//                   Text(
//                     name,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.center,
//                   ),
//                   if (size != null) ...[
//                     const SizedBox(height: 4),
//                     Text(_formatSize(size), style: Theme.of(context).textTheme.bodySmall),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Table View
//   Widget _buildTable() {
//     final items = widget.items;

//     final rows = items.map((item) {
//       final icon = widget.iconOf?.call(item) ?? Icons.insert_drive_file;
//       final name = widget.nameOf(item);
//       final size = widget.sizeOf?.call(item);
//       final modified = widget.modifiedOf?.call(item);
//       return DataRow(
//         cells: [
//           DataCell(Row(
//             children: [
//               Icon(icon, size: 18),
//               const SizedBox(width: 8),
//               Flexible(child: Text(name, overflow: TextOverflow.ellipsis)),
//             ],
//           ), onTap: widget.onTap == null ? null : () => widget.onTap!(item)),
//           DataCell(Text(size == null ? '-' : _formatSize(size))),
//           DataCell(Text(modified == null ? '-' : _formatDate(modified))),
//         ],
//       );
//     }).toList();

//     // Wrap in horizontal + vertical scroll to avoid overflow for large tables
//     return Padding(
//       padding: widget.padding,
//       child: Scrollbar(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(minWidth: 600),
//             child: SingleChildScrollView(
//               child: DataTable(
//                 columns: const [
//                   DataColumn(label: Text('Name')),
//                   DataColumn(label: Text('Size')),
//                   DataColumn(label: Text('Modified')),
//                 ],
//                 rows: rows,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatSize(int bytes) {
//     const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
//     double size = bytes.toDouble();
//     int tier = 0;
//     while (size >= 1024 && tier < suffixes.length - 1) {
//       size /= 1024;
//       tier++;
//     }
//     if (tier == 0) return '$bytes B';
//     return '${size.toStringAsFixed(size >= 100 ? 0 : size >= 10 ? 1 : 2)} ${suffixes[tier]}';
//   }

//   String _formatDate(DateTime dt) {
//     // yyyy-MM-dd HH:mm
//     String two(int n) => n.toString().padLeft(2, '0');
//     return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
//   }
// }
