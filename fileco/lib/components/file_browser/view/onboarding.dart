import 'package:flutter/material.dart';
import './home_screen.dart';

class ZomoOnboardingScreen extends StatefulWidget {
  const ZomoOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<ZomoOnboardingScreen> createState() => _ZomoOnboardingScreenState();
}

class _ZomoOnboardingScreenState extends State<ZomoOnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.78,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    
    // Start the loading animation
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B5FFF),
              Color(0xFF6B46C1),
              Color(0xFF553C9A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Background decorative elements
                    _buildBackgroundElements(),
                    
                    // Main content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 80),
                          
                          // Main folder icon
                          _buildMainFolderIcon(),
                          
                          const SizedBox(height: 60),
                          
                          // Title and subtitle
                          const Text(
                            'Explore Your Files\nWith Zomo App',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          
                          const SizedBox(height: 60),
                          
                          // Start Now button
                          _buildStartButton(),
                          
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Progress section
              _buildProgressSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        // Lock icon (top left)
        Positioned(
          top: 100,
          left: 40,
          child: _buildLockIcon(),
        ),
        
        // Folder icon (bottom right)
        Positioned(
          bottom: 200,
          right: 40,
          child: _buildSmallFolderIcon(),
        ),
        
        // Decorative arrows
        Positioned(
          top: 200,
          right: 60,
          child: _buildArrow(0.3),
        ),
        Positioned(
          bottom: 250,
          left: 50,
          child: _buildArrow(-0.5),
        ),
      ],
    );
  }

  Widget _buildMainFolderIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Folder base
          Container(
            width: 70,
            height: 55,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B9D),
                  Color(0xFFFF8E9B),
                  Color(0xFFFFB199),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          
          // Folder tab
          Positioned(
            top: 20,
            left: 35,
            child: Container(
              width: 25,
              height: 8,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF6B9D),
                    Color(0xFFFF8E9B),
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          
          // Plus icon
          const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildLockIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: const Icon(
        Icons.lock_outline,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildSmallFolderIcon() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: const Icon(
        Icons.folder_outlined,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildArrow(double rotation) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        Icons.arrow_forward,
        color: Colors.white.withOpacity(0.3),
        size: 20,
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: () {
          // Handle start button press
          print('Start Now pressed');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00D4AA),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: const Text(
          'Start Now',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            '78% Files Loading...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}