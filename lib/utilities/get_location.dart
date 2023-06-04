import 'package:ati_all_in_one/services/send_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    debugPrint('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    debugPrint('Location permissions are permanently denied, we cannot request permissions.');
  } 
  var myPosition = await Geolocator.getCurrentPosition();
  

  // debugPrint("lat.latitude: ${myPosition.latitude}");
  getLocationFromLatLong(myPosition.latitude,myPosition.longitude);
}



void getLocationFromLatLong(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[4];
      String location = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}-${placemark.postalCode}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';

      sendLocation('', '$latitude', '$longitude', location, '');
    }
  } catch (e) {
    debugPrint('e: $e');
  }
}
