import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 4),
          _buildupnav(context),
          SizedBox(height: 10),
          buildCardSlider(),
          SizedBox(height: 20),
          Expanded(child: GridCard()),
        ],
      ),
    );
  }
}

Widget _buildupnav(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          //TODO: It should contain a drawer icon
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Icon(Icons.menu_sharp, size: 25.0),
        ),
    
        Text("My Files", style: TextStyle()),
    
        Container(
          //TODO: It should contain a search
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Icon(Icons.search, size: 25.0),
        ),
      ],
    ),
  );
}

Widget buildCardSlider() {
  final String title = 'Cloud Storage';
  final double progress = 0.7;

  return Stack(
    alignment: Alignment.topCenter,
    children: [
      Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 380,
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/folders.png',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 220, // Adjusted to be below the image
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '26GB of 34Gb',
                      style: TextStyle(
                        fontSize: 17,
                        color: const Color.fromARGB(179, 27, 25, 25),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Bar at the Bottom
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.4),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

final List<Map<String, dynamic>> cardData = [
  {
    'name': 'Picture',
    'description': '1200 pictures',
    'image': 'assets/images/files.png',
    'route': '/documents',
    'color': Colors.deepPurpleAccent,
  },
  {
    'name': 'video',
    'description': '200 videos',
    'image': 'assets/images/videos.png',
    'route': '/videos',
    'color': Colors.yellowAccent,
  },
  {
    'name': 'Music',
    'description': '156 songs',
    'image': 'assets/images/music.png',
    'route': '/music',
    'color': Colors.purple,
  },
  {
    'name': 'Documents',
    'description': '245 files',
    'image': 'assets/images/documents.png',
    'route': '/documents',
    'color': Colors.blue,
  },
];

Widget buildCard(BuildContext context, Map<String, dynamic> cardInfo) {
  return GestureDetector(
    onTap: () {
      // Navigate to the specified route
      Navigator.pushNamed(context, cardInfo['route']);
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              cardInfo['color'].withOpacity(0.1),
              cardInfo['color'].withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image/Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: cardInfo['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                cardInfo['image'],
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image doesn't exist
                  return Icon(
                    _getIconForType(cardInfo['name']),
                    size: 40,
                    color: cardInfo['color'],
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            
            // Name
            Text(
              cardInfo['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            
            // Description
            Text(
              cardInfo['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}


IconData _getIconForType(String type){
  switch (type.toLowerCase()) {
    case 'documents':
      return Icons.description;
    case 'images':
      return Icons.image;
    case 'videos':
      return Icons.video_library;
    case 'music':
      return Icons.music_note;
    default:
      return Icons.folder;
  }
}

Widget GridCard() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0, // Square cards
      ),
      itemCount: cardData.length, // This will create 2 rows with 2 items each
      itemBuilder: (context, index) {
        return Builder(
          builder: (context) => buildCard(context, cardData[index]),
        );
      },
    ),
  );
}