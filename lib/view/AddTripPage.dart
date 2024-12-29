import 'package:flutter/material.dart';

class AddTripPage extends StatelessWidget {
  const AddTripPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Add your trip details here.',
          style: TextStyle(fontSize: 18),
        ),

      ),

    );
  }
}
