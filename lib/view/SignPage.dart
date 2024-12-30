import 'package:flutter/material.dart';
import 'package:travel_lanka/view/MainPage.dart';
import 'package:travel_lanka/view/SignUpPage.dart';
import 'package:travel_lanka/view/SignInPage.dart';
class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const RoundedRectangleBorder(
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
            const SizedBox(height: 5),
            Container(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {

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
            const SizedBox(height: 30),
            Container(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage(email: "",username: "Guest",)),
                  );
                },
                child: const Text(
                  'Continue as Guest',
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
