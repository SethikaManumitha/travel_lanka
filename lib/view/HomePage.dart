import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController(); // Renamed here

  final CollectionReference places = FirebaseFirestore.instance.collection('places');

  // Add place
  Future<void> addPlace(String place, String description, String image) async {
    try {
      await places.add({
        'place': place,
        'descript': description,
        'image': image,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add place: $e')),
      );
    }
  }

  // Update place
  Future<void> updatePlace(String docId, String newPlace, String newDescription, String newImage) async {
    try {
      await places.doc(docId).update({
        'place': newPlace,
        'descript': newDescription,
        'image': newImage,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update place: $e')),
      );
    }
  }

  // Delete place
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

  @override
  void dispose() {
    placeController.dispose();
    descriptionController.dispose();
    imageController.dispose(); // Renamed here as well
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase CRUD for Places')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // TextFields for input
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
              controller: imageController, // Renamed here as well
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (placeController.text.trim().isEmpty || descriptionController.text.trim().isEmpty || imageController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }
                addPlace(
                  placeController.text.trim(),
                  descriptionController.text.trim(),
                  imageController.text.trim(), // Renamed here as well
                );
                placeController.clear();
                descriptionController.clear();
                imageController.clear(); // Renamed here as well
              },
              child: const Text('Add Place'),
            ),
            const SizedBox(height: 10),
            Expanded(
              // Real-time data display
              child: StreamBuilder(
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
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final doc = data[index];
                      final place = doc['place'];
                      final description = doc['descript'];
                      final image = doc['image']; // Renamed here
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text(place),
                          subtitle: Text(description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  final newPlaceController = TextEditingController(text: place);
                                  final newDescriptionController = TextEditingController(text: description);
                                  final newImageController = TextEditingController(text: image);
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Update Place'),
                                      content: Column(
                                        children: [
                                          TextField(
                                            controller: newPlaceController,
                                            decoration: const InputDecoration(
                                              labelText: 'New Place',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: newDescriptionController,
                                            decoration: const InputDecoration(
                                              labelText: 'New Description',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller: newImageController, // Renamed here
                                            decoration: const InputDecoration(
                                              labelText: 'New Image URL',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (newPlaceController.text.trim().isEmpty ||
                                                newDescriptionController.text.trim().isEmpty ||
                                                newImageController.text.trim().isEmpty) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('All fields are required')),
                                              );
                                              return;
                                            }
                                            updatePlace(
                                              doc.id,
                                              newPlaceController.text.trim(),
                                              newDescriptionController.text.trim(),
                                              newImageController.text.trim(), // Renamed here
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Update'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // Delete button
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deletePlace(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
