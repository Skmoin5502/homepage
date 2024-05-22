  import 'package:flutter/material.dart';
  import 'package:geocoding/geocoding.dart';
  import 'package:geolocator/geolocator.dart';
import 'package:homepage/profile_screen.dart';
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
                    Container(
                      padding: EdgeInsets.only(right: 10), // Adjust padding as needed
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '  Delivery in ',
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
                    ),
                    LocationButton(), // Location Button
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to DemoPage
                  );
                },
                child: ProfileImage(), // Use CircularProfileImageWidget
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarWidget(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SnacksAndDrinksSection(), // New Snacks & Drinks Section
                      SizedBox(height: 20),
                      SnacksAndDrinksSection(),
                      SizedBox(height: 20),
                      SnacksAndDrinksSection(),
                      SizedBox(height: 20),
                      SnacksAndDrinksSection(),

                      // Additional content can be added here
                    ],
                  ),
                ),
              ),
            ),
          ],
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
          SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4, // Set to 4 to display four images per row
            childAspectRatio: 0.7, // Adjust this as needed for a better fit
            physics: NeverScrollableScrollPhysics(), // Prevent grid from scrolling independently
            children: [
              SnacksAndDrinksItem(image: 'assets/cleaners.png', name: 'Item 1'),
              SnacksAndDrinksItem(image: 'assets/cleaners.png', name: 'Item 2'),
              SnacksAndDrinksItem(image: 'assets/cleaners.png', name: 'Item 3'),
              SnacksAndDrinksItem(image: 'assets/cleaners.png', name: 'Item 4'),
              SnacksAndDrinksItem(image: 'assets/cleaners.png', name: 'Item 5'),
              SnacksAndDrinksItem(image: 'assets/cleaners.png', name: 'Item 6'),
              SnacksAndDrinksItem(image: 'assets/cleaners.png', name: 'Item 7'),
              SnacksAndDrinksItem(image: 'assets/cleaners.png', name: 'Item 8'),
            ],
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
      return Column(
        children: [
          Card(
            //color: Colors.lightBlueAccent, // Change this to the desired color
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Add padding inside the card
              child: Image.asset(
                image,
                width: 70, // Decrease the width for better fit
                height: 70, // Decrease the height for better fit
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12), // Adjust text size as needed
          ),
        ],
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
          title: Text('Not In Location'),
        ),
        body: Center(
          child: Text('You are not in Mumbra!'),
        ),
      );
    }
  }
