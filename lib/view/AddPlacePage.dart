import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/widget/CustomDrawer.dart';

class AddPlacePage extends StatefulWidget {
  @override
  _AddPlacePageState createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final TextEditingController placeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  final CollectionReference places = FirebaseFirestore.instance.collection('places');

  // Add place
  Future<void> addPlace(String place, String description, String image, String tag) async {
    try {
      await places.add({
        'place': place,
        'descript': description,
        'image': image,
        'tag': tag,
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
  Future<void> updatePlace(String docId, String newPlace, String newDescription, String newImage, String newTag) async {
    try {
      await places.doc(docId).update({
        'place': newPlace,
        'descript': newDescription,
        'image': newImage,
        'tag': newTag,
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
    imageController.dispose();
    tagController.dispose();
    super.dispose();
  }

  void showAddPlaceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Place'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              TextField(
                controller: tagController,
                decoration: const InputDecoration(
                  labelText: 'Tag (e.g., #Beach)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
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
              if (placeController.text.trim().isEmpty ||
                  descriptionController.text.trim().isEmpty ||
                  imageController.text.trim().isEmpty ||
                  tagController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All fields are required')),
                );
                return;
              }
              addPlace(
                placeController.text.trim(),
                descriptionController.text.trim(),
                imageController.text.trim(),
                tagController.text.trim(),
              );
              placeController.clear();
              descriptionController.clear();
              imageController.clear();
              tagController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void showUpdatePlaceDialog(String docId, String currentPlace, String currentDescription, String currentImage, String currentTag) {
    placeController.text = currentPlace;
    descriptionController.text = currentDescription;
    imageController.text = currentImage;
    tagController.text = currentTag;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Place'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              TextField(
                controller: tagController,
                decoration: const InputDecoration(
                  labelText: 'Tag (e.g., #Beach)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
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
              if (placeController.text.trim().isEmpty ||
                  descriptionController.text.trim().isEmpty ||
                  imageController.text.trim().isEmpty ||
                  tagController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All fields are required')),
                );
                return;
              }
              updatePlace(
                docId,
                placeController.text.trim(),
                descriptionController.text.trim(),
                imageController.text.trim(),
                tagController.text.trim(),
              );
              placeController.clear();
              descriptionController.clear();
              imageController.clear();
              tagController.clear();
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
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
                      final image = doc['image'];
                      final tag = doc['tag'];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text(place),
                          subtitle: Text('$description\nTag: $tag'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => showUpdatePlaceDialog(doc.id, place, description, image, tag),
                              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPlaceDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
