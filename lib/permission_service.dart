import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler package

class LocationPermissionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Location Permission'),
      content: Text('Would you like to enable location services?'),
      actions: [
        TextButton(
          onPressed: () {
            // Handle when user denies location permission
            Navigator.pop(context);
          },
          child: Text('No'),
        ),
        TextButton(
          onPressed: () async {
            // Check if permission is already granted
            PermissionStatus permission = await Permission.location.status;
            if (permission != PermissionStatus.granted) {
              // Request location permission
              permission = await Permission.location.request();
              if (permission != PermissionStatus.granted) {
                // Location permission is not granted
                if (await openAppSettings()) {
                  // User opened app settings, handle accordingly
                }
                return;
              }
            }

            // Location permission is granted
            Navigator.pop(context);
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}
