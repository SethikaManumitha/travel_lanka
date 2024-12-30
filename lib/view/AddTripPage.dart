import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_lanka/widget/PlaceList.dart';

class AddTripPage extends StatefulWidget {
  final String email;

  const AddTripPage({Key? key,required this.email}) : super(key: key);

  @override
  _AddTripPageState createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> placeList = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedCategory;
  final DateFormat _dateFormat = DateFormat('EEE, dd MMM yyyy');
  String selectedDistrict = 'Colombo';

  Future<void> _saveTrip() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (placeList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one place')),
        );
        return;
      }

      try {
        final String tripName = _nameController.text.trim();
        final String userEmail = widget.email;

        Map<String, dynamic> tripData = {
          'destination': selectedDistrict,
          'enddate': Timestamp.fromDate(_endDate),
          'name': tripName,
          'placeList': placeList,
          'startdate': Timestamp.fromDate(_startDate),
          'user': userEmail,
        };

        await _firestore.collection('trip').add(tripData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip saved successfully!')),
        );

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving trip: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan a Trip',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTrip,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Trip Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a trip name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Container(
                width: 400,
                child: ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(
                    'Start Date: ${_dateFormat.format(_startDate)}', // Format start date
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 400,
                child: ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(
                    'End Date: ${_dateFormat.format(_endDate)}', // Format end date
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDistrict,
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Destination',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Colombo',
                  'Gampaha',
                  'Kandy',
                  'Galle',
                  'Matara',
                  'Jaffna',
                ].map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Hotel',
                  'LandMark',
                  'Restaurant',
                  'Park',
                  'ATM',
                  'Gas Station',
                ].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Select Places:'),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
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
                      return Column(
                        children: places.map((doc) {
                          final place = doc['place'];
                          final description = doc['descript'];
                          final image = doc['image'];
                          final category = doc['category'];
                          final docId = doc.id;


                          bool isAdded = placeList.contains(docId);

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
                              setState(() {
                                if (isAdded) {
                                  placeList.remove(docId);

                                } else {
                                  placeList.add(docId);

                                }
                                print(placeList);
                                isAdded = !isAdded;
                              });
                            },
                            isAdded: isAdded, // Pass dynamic isAdded state
                          );
                        }).toList(),
                      );

                    },
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate.subtract(const Duration(days: 1));
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _getFilteredPlaces() {
    Query query = _firestore.collection('places');
    if (selectedDistrict.isNotEmpty) {
      query = query.where('district', isEqualTo: selectedDistrict);
    }
    if (_selectedCategory != null) {
      query = query.where('category', isEqualTo: _selectedCategory);
    }
    return query.snapshots();
  }
}

