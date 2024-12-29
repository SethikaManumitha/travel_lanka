import 'package:flutter/material.dart';
import 'package:travel_lanka/view/AddTripPage.dart';
class ViewTripPage extends StatelessWidget {
  const ViewTripPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'No Trips Yet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              Container(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTripPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Create A Trip',
                    style: TextStyle(fontSize: 18, color: Colors.white), // Button text color set to white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
