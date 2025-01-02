import 'package:flutter/material.dart';
import 'package:travel_lanka/view/HomePage.dart';
import 'package:travel_lanka/view/ViewTripsPage.dart';
import 'package:travel_lanka/view/ViewPlacePage.dart';
import 'package:travel_lanka/widget/CustomDrawer.dart';

class MainPage extends StatefulWidget {
  final String email;
  final String username;

  const MainPage({Key? key, required this.email, required this.username}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  void _onNavigate(int index) {
    if (widget.username == 'Guest' && index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feature unavailable for Guest user")),
      );
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _pages.addAll([
      const HomePage(),
      const FavoritesScreen(),
      ViewTripsPage(email: widget.email),
      ViewPlacePage(email: widget.email),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Travel Lanka',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(
        onNavigate: _onNavigate,
        currentIndex: _currentIndex,
        userName: widget.username,
        email: widget.email,
      ),
      body: Column(
        children: [
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigate,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: widget.username == 'Guest' ? 'Disabled' : 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: widget.username == 'Guest' ? 'Disabled' : 'Trip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_sharp),
            label: widget.username == 'Guest' ? 'Disabled' : 'Place',
          ),
        ],
        selectedItemColor: widget.username == 'Guest' ? Colors.grey : Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Favorites Screen', style: TextStyle(fontSize: 24)),
    );
  }
}
