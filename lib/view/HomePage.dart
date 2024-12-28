import 'package:flutter/material.dart';
import 'package:travel_lanka/widget/CustomDrawer.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        actions: [
          IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Categories
            Text("Category", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  5,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      child: Text("Cat"),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Most Recommended
            Text("Most Recommended", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  3,
                      (index) => Container(
                    width: 150,
                    height: 100,
                    margin: EdgeInsets.only(right: 10),
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Create Your Plan
            Text("Create Your Plan...", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Icon(Icons.add, size: 50),
              ),
            ),
            SizedBox(height: 20),

            // Top Restaurants
            Text("Top Restaurants", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  3,
                      (index) => Container(
                    width: 150,
                    height: 100,
                    margin: EdgeInsets.only(right: 10),
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
