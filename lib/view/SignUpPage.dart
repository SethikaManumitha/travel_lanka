import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/view/MainPage.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String username, String email, String password) async {
    try {
      await users.add({
        'username': username,
        'email': email,
        'password': password,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign Up successful!')),
      );

      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Username field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
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
            // Sign Up Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set button color
                minimumSize: const Size(double.infinity, 50), // Make the button wide
              ),
              onPressed: () {
                // Get input values from the text controllers
                String username = _usernameController.text.trim();
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();

                // Basic validation for empty fields
                if (username.isEmpty || email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All fields must be filled")),
                  );
                  return;
                }

                // Call the addUser function to add user data to Firestore
                addUser(username, email, password);
              },
              child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
