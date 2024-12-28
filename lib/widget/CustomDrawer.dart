import 'package:flutter/material.dart';
import 'package:travel_lanka/view/CurrencyConverterPage.dart';
import 'package:travel_lanka/view/AboutPage.dart';
import 'package:travel_lanka/view/AddPlacePage.dart';
import 'package:travel_lanka/view/HomePage.dart';
import 'package:travel_lanka/view/SignInPage.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Future<void> logout(BuildContext context) async {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You have logged out.")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Text(
              'Travel Lanka',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text('Places'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Places page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPlacePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_travel),
            title: const Text('Trips'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Trips page
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Favorites page
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency Converter'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurrencyConverterPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to About page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutPage(),
                ),
              );
            },
          ),
          // Logout section
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              logout(context); // Call logout function
            },
          ),
        ],
      ),
    );
  }
}
