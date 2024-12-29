import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/view/MainPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> signInUser(String email, String password) async {
    try {
      // Query the users collection for the provided email
      var userQuery = await users.where('email', isEqualTo: email).get();

      // Check if a user with the email exists
      if (userQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found with this email')),
        );
        return;
      }

      // Check if the password matches the one stored for that email
      var userData = userQuery.docs.first.data() as Map<String, dynamic>;
      if (userData['password'] == password) {
        // Navigate to the MainPage with email and password
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(email: email, username: userData['username']),
          ),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true, // Hide password text
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            // Sign In Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set button color
                minimumSize: const Size(double.infinity, 50), // Make the button wide
              ),
              onPressed: () {
                // Get input values from the text controllers
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();

                // Basic validation for empty fields
                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Both fields must be filled")),
                  );
                  return;
                }

                // Call the signInUser function to authenticate the user
                signInUser(email, password);
              },
              child: const Text('Sign In', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
