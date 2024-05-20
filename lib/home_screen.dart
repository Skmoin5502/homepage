import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'circular_profile_image_widget.dart';
import 'search_bar_widget.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20), // Add SizedBox for spacing
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Delivery in ',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        TextSpan(
                          text: '7',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        TextSpan(
                          text: ' Mins ',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  LocationButton(), // Location Button
                ],
              ),
            ),
            ProfileImage(), // Use CircularProfileImageWidget
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchBarWidget(),
              SizedBox(height: 20),
              SnacksAndDrinksSection(), // New Snacks & Drinks Section
              SizedBox(height: 20),
              // Additional content can be added here
            ],
          ),
        ),
      ),
    );
  }
}

class SnacksAndDrinksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Snacks & Drinks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SnacksAndDrinksItem(image: 'path/to/image1.jpg', name: 'Item 1'),
              SnacksAndDrinksItem(image: 'path/to/image2.jpg', name: 'Item 2'),
              SnacksAndDrinksItem(image: 'path/to/image3.jpg', name: 'Item 3'),
              SnacksAndDrinksItem(image: 'path/to/image4.jpg', name: 'Item 4'),
            ],
          ),
        ),
        SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SnacksAndDrinksItem(image: 'path/to/image5.jpg', name: 'Item 5'),
              SnacksAndDrinksItem(image: 'path/to/image6.jpg', name: 'Item 6'),
              SnacksAndDrinksItem(image: 'path/to/image7.jpg', name: 'Item 7'),
              SnacksAndDrinksItem(image: 'path/to/image8.jpg', name: 'Item 8'),
            ],
          ),
        ),
      ],
    );
  }
}

class SnacksAndDrinksItem extends StatelessWidget {
  final String image;
  final String name;

  SnacksAndDrinksItem({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 100,
      child: Column(
        children: [
          Image.asset(
            image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 5),
          Text(
            name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LocationButton extends StatefulWidget {
  @override
  _LocationButtonState createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  Position? position;
  List<Placemark>? placeMarks;
  String? completeAddress;

  Future<void> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Service Disabled'),
            content: Text('Please enable location services to proceed.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Request location permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Required'),
            content: Text('Please grant location permission to proceed.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Denied'),
            content: Text('Location permission is permanently denied, we cannot request permissions.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Fetch current location
    try {
      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placeMarks = await placemarkFromCoordinates(
        newPosition.latitude,
        newPosition.longitude,
      );

      Placemark pMark = placeMarks[0];

      setState(() {
        completeAddress = ' ${pMark.subLocality}, ${pMark.locality}, ${pMark.postalCode}, ${pMark.country}';

        // Check sublocality and redirect if not "Mumbra"
        if (pMark.subLocality != "Mumbra") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NotInLocationPage()),
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white, // Set the background color
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // Align bottom sheet above keyboard
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Select Address',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.search),
                      title: TextField(
                        style: TextStyle(color: Colors.black), // Set text color
                        decoration: InputDecoration(
                          hintText: 'Search for area, street name...',
                          hintStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.my_location_sharp),
                      title: Text(
                        'Go to Current Location',
                        style: TextStyle(color: Colors.green),
                      ),
                      onTap: () {
                        getCurrentLocation(context);
                        Navigator.pop(context); // Close the bottom sheet after initiating location fetch
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.arrow_downward),
                      title: Text(
                        'Recently Searched Locations',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(
                        'Thane - 400612 , Maharashtra, India',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    // Add more list tiles as needed
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Text(
          completeAddress ?? 'Thane, Maharashtra,400612 India ',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class NotInLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Check'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.location_off,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Sorry, We Are Currently Not in This Location',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DemoPage()),
                );
              },
              child: Text('Try Changing Location'),
            ),
          ],
        ),
      ),
    );
  }
}

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Page'),
      ),
      body: Center(
        child: Text(
          'This is the demo page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// class ProfileImage is removed as it's replaced with CircularProfileImageWidget

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
