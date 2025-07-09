import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}


Widget _buildHeader() {
  return Column(
    children: [
      Text("Welcome To FILECO",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      SizedBox(height: 6),
       Text("Create an Account to get started on your Health and Happiness Journey",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      SizedBox(height: 14),

      //TODO: LOADER
      ProgressBar(),
    ],
  );
}



Widget BuildFormButton(){
  return Column(
    children:[
      ElevatedButton(
        
      ),

    ],
  );
}