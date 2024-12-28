import 'package:flutter/material.dart';
import 'package:travel_lanka/view/SignUpPage.dart';
import 'package:travel_lanka/view/SignInPage.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sign In Button - Red Color and Rectangular Shape
            Container(
              width: 250, // Adjust the width to your preference
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Rectangular button
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20), // Space between the buttons
            // Sign Up Button - Rectangular Shape
            Container(
              width: 250, // Adjust the width to your preference
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Rectangular button
                  ),
                ),
                onPressed: () {
                  // Navigate to the SignUpPage when Sign Up button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
