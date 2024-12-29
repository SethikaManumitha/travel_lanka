import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/widget/PlaceList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _searchQuery;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                      hintText: "Search by district...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                    label: const Text("All"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: _selectedCategory == null ? Colors.red : Colors.grey[300],
                      foregroundColor: _selectedCategory == null ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = "Hotel";
                      });
                    },
                    icon: const Icon(Icons.bed),
                    label: const Text("Hotel"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: _selectedCategory == "Hotel" ? Colors.red : Colors.grey[300],
                      foregroundColor: _selectedCategory == "Hotel" ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = "LandMark";
                      });
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text("LandMark"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: _selectedCategory == "LandMark" ? Colors.red : Colors.grey[300],
                      foregroundColor: _selectedCategory == "LandMark" ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = "Restaurant";
                      });
                    },
                    icon: const Icon(Icons.restaurant),
                    label: const Text("Restaurant"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: _selectedCategory == "Restaurant" ? Colors.red : Colors.grey[300],
                      foregroundColor: _selectedCategory == "Restaurant" ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = "Park";
                      });
                    },
                    icon: const Icon(Icons.park),
                    label: const Text("Park"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: _selectedCategory == "Park" ? Colors.red : Colors.grey[300],
                      foregroundColor: _selectedCategory == "Park" ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = "ATM";
                      });
                    },
                    icon: const Icon(Icons.attach_money),
                    label: const Text("ATM"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: _selectedCategory == "ATM" ? Colors.red : Colors.grey[300],
                      foregroundColor: _selectedCategory == "ATM" ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = "Gas Station";
                      });
                    },
                    icon: const Icon(Icons.local_gas_station),
                    label: const Text("Gas Station"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: _selectedCategory == "Gas Station" ? Colors.red : Colors.grey[300],
                      foregroundColor: _selectedCategory == "Gas Station" ? Colors.white : Colors.black,
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 20),

            // Most Recommended Places
            Text("Most Recommended", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _getFilteredPlaces(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data.'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final places = snapshot.data!.docs;
                if (places.isEmpty) {
                  return const Center(child: Text('No places found.'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final doc = places[index];
                    final place = doc['place'];
                    final description = doc['descript'];
                    final image = doc['image'];
                    final category = doc['category'];
                    bool isAdded = false;
                    return PlaceList(
                      place: place,
                      description: description,
                      image: image,
                      category: category,
                      rating: 4.5,
                      isFavorite: false,
                      onFavoriteToggle: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Favorite toggled!')),
                        );
                      },
                      onAdd: () {
                        isAdded = !isAdded;
                      },
                      isAdded: isAdded,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),


    );
  }

  // Filter firestore results
  Stream<QuerySnapshot> _getFilteredPlaces() {
    Query query = _firestore.collection('places');
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      query = query.where('district', isEqualTo: _searchQuery);
    }
    if (_selectedCategory != null) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }
    return query.snapshots();
  }
}

