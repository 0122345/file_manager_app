# FileCo - Universal File Manager

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)](https://developer.apple.com/ios)

A powerful, cross-platform file manager built with Flutter that provides comprehensive file management capabilities for videos, music, documents, and phone storage optimization.

## 🚀 Features

### 📁 File Management

- **Store & Organize**: Efficiently store and categorize your files
- **Multi-format Support**: Handle videos, music, documents, and more
- **Intuitive Navigation**: Easy-to-use folder structure and file browsing

### 🎵 Media Player

- **Video Playback**: Built-in video player with multiple format support
- **Music Player**: Integrated audio player with playlist management
- **Media Controls**: Standard playback controls with seek functionality

### 📱 Storage Management

- **Secondary Memory**: Manage phone's secondary storage efficiently
- **Storage Analysis**: Monitor storage usage and optimize space
- **File Operations**: Copy, move, delete, and rename files seamlessly

### 🗂️ Document Handling

- **Document Viewer**: Preview various document formats
- **File Search**: Quick search functionality across all file types
- **Recent Files**: Easy access to recently used files

## 📱 Platform Support

- ✅ **Android** - Fully supported
- ✅ **iOS** - Fully supported
- 🔄 **Desktop** - Coming soon
- 🔄 **Web** - Planned for future release

## 🛠️ Installation

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode for platform-specific development

### Clone Repository

```bash
git clone https://github.com/0122345/file_manager_app.git
cd fileco
```

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For specific device
flutter devices
flutter run -d [device-id]
```

## 🏗️ Build

### Android APK

```bash
flutter build apk --release
```

### iOS IPA

```bash
flutter build ios --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

## 📋 Requirements

### System Requirements

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Storage**: Minimum 100MB free space
- **RAM**: 2GB recommended

### Permissions

- Storage access for file management
- Media access for video/audio playback
- Network access for cloud features (if applicable)

## 🎯 Usage

1. **Launch FileCo** on your device
2. **Grant Permissions** when prompted for storage access
3. **Browse Files** using the intuitive folder navigation
4. **Play Media** by tapping on video or audio files
5. **Manage Storage** through the storage analyzer
6. **Organize Files** using copy, move, and delete operations

## 🏛️ Architecture

FileCo follows clean architecture principles with clear separation of concerns:

```txt
lib/
├── core/           # Core utilities and constants
├── data/           # Data sources and repositories
├── components/     # Features for the app
└── main.dart       # Application entry point
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

- Follow Dart's official style guide
- Use meaningful variable and function names
- Add comments for complex logic
- Write unit tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🐛 Issues & Support

- **Bug Reports**: Use the [Issues](https://github.com/yourusername/fileco/issues) tab
- **Feature Requests**: Create an issue with the "enhancement" label
- **Questions**: Check our [Discussions](https://github.com/yourusername/fileco/discussions) section

## 📞 Contact

- **Developer**: Ntwari Ashimwe Fiacre
- **Email**: <ntwarifiacre043@gmail.com>
- **Project Link**: [https://github.com/0122345/file_manager_app.git](https://github.com/0122345/file_manager_app.git)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Open source community for inspiration
- Contributors who help improve FileCo

## 📈 Roadmap

- [ ] Desktop support (Windows, macOS, Linux)
- [ ] Web version
- [ ] Cloud storage integration
- [ ] Advanced file encryption
- [ ] Batch operations
- [ ] Theme customization
- [ ] Plugin system

---

## **Made with ❤️ using Flutter**

*FileCo - Your files, organized and accessible everywhere.*
