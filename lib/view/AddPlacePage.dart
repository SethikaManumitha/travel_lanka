import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/widget/CustomDrawer.dart';
import 'package:travel_lanka/widget/PlaceCard.dart';

class AddPlacePage extends StatefulWidget {
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final CollectionReference places = FirebaseFirestore.instance.collection('places');
  String selectedCategory = 'Restaurant'; // Default category
  String? updatingDocId;

  Future<void> addOrUpdatePlace(String place, String description, String image, String category) async {
    try {
      if (updatingDocId == null) {
        // Add a new place
        await places.add({
          'place': place,
          'descript': description,
          'image': image,
          'category': category,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Place added successfully!')),
        );
      } else {
        // Update an existing place
        await places.doc(updatingDocId).update({
          'place': place,
          'descript': description,
          'image': image,
          'category': category,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Place updated successfully!')),
        );
        updatingDocId = null; // Reset the update mode
      }
      clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save place: $e')),
      );
    }
  }

  void clearForm() {
    placeController.clear();
    descriptionController.clear();
    imageController.clear();
    selectedCategory = 'Restaurant';
    updatingDocId = null;
  }

  @override
  void dispose() {
    placeController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void showAddPlaceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(updatingDocId == null ? 'Add Place' : 'Update Place'),
          contentPadding: const EdgeInsets.all(16.0),  // Optional: To add space around the content
          content: Container(
            width: 600,
            height: 270, // Increase the height of the dialog box
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: placeController,
                    decoration: const InputDecoration(
                      labelText: 'Place',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'Restaurant',
                      'Hotel',
                      'LandMark',
                      'Beach',
                      'Park',
                      'Museum',
                    ].map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (placeController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty ||
                    imageController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }
                addOrUpdatePlace(
                  placeController.text.trim(),
                  descriptionController.text.trim(),
                  imageController.text.trim(),
                  selectedCategory,
                );
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: Text(updatingDocId == null ? 'Add Place' : 'Update Place'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Places',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const CustomDrawer(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder(
                stream: places.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading data.'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final data = snapshot.data!.docs;
                  if (data.isEmpty) {
                    return const Center(child: Text('No places found.'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final doc = data[index];
                      final place = doc['place'];
                      final description = doc['descript'];
                      final image = doc['image'];
                      final category = doc['category'];

                      // Use the PlaceCard widget instead of ListTile
                      return PlaceCard(
                        place: place,
                        description: description,
                        image: image,
                        category: category,
                        rating: 4.5,
                        isFavorite: false,
                        onFavoriteToggle: () {
                          // Implement favorite toggle functionality here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Favorite toggled!')),
                          );
                        },
                        onEdit: () {
                          setState(() {
                            updatingDocId = doc.id;
                            placeController.text = place;
                            descriptionController.text = description;
                            imageController.text = image;
                            selectedCategory = category;
                          });
                          showAddPlaceDialog(context);
                        },
                        onDelete: () => deletePlace(doc.id),
                      );
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddPlaceDialog(context); // Show dialog when FAB is pressed
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> deletePlace(String docId) async {
    try {
      await places.doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete place: $e')),
      );
    }
  }
}
