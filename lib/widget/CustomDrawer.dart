import 'package:flutter/material.dart';
import 'package:travel_lanka/view/CurrencyConverterPage.dart';
import 'package:travel_lanka/view/AboutPage.dart';
import 'package:travel_lanka/view/SignInPage.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onNavigate;
  final int currentIndex;

  const CustomDrawer({
    Key? key,
    required this.onNavigate,
    required this.currentIndex,
  }) : super(key: key);

  Future<void> logout(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You have logged out.")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(
              'User Name',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            accountEmail: Text(
              'user@example.com',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://placehold.co/600x400'),
            ),
            decoration: BoxDecoration(color: Colors.red),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: currentIndex == 0, // Highlight the current item
            onTap: () {
              Navigator.pop(context);
              onNavigate(0); // Set index for BottomNavigationBar
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            selected: currentIndex == 1,
            onTap: () {
              Navigator.pop(context);
              onNavigate(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Trips'),
            selected: currentIndex == 2,
            onTap: () {
              Navigator.pop(context);
              onNavigate(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_sharp),
            title: const Text('Place'),
            selected: currentIndex == 3,
            onTap: () {
              Navigator.pop(context);
              onNavigate(3);
            },
          ),
          // Adding About and Currency Converter options here
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context); // Close drawer before navigating
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency Converter'),
            onTap: () {
              Navigator.pop(context); // Close drawer before navigating
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurrencyConverterPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              logout(context); // Logout
            },
          ),
        ],
      ),
    );
  }
}
