import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/model/PlaceModel.dart';

class PlaceController {

  // Create an instance of the place collection
  final CollectionReference placesCollection = FirebaseFirestore.instance.collection('places');

  // Add Places
  Future<void> addPlace(Place place) async {
    try {
      await placesCollection.add(place.toMap());
    } catch (e) {
      throw Exception('Failed to add place: $e');
    }
  }

  // Update Places
  Future<void> updatePlace(String docId, Place place) async {
    try {
      await placesCollection.doc(docId).update(place.toMap());
    } catch (e) {
      throw Exception('Failed to update place: $e');
    }
  }


}
