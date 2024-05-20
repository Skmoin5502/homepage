import 'package:flutter/material.dart';
import 'package:homepage/home_screen.dart';

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
              size: 120,
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
                  MaterialPageRoute(builder: (context) => HomePage()),
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

// class DemoPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Demo Page'),
//       ),
//       body: Center(
//         child: Text(
//           'This is the demo page',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
