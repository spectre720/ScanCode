import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';

class deviceInfo {
  deviceInfo();
  Future<void> printDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print('Android ID: ${androidInfo.androidId}');
        print('Device Model: ${androidInfo.model}');
        // Add more Android-specific properties as needed
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        print('IDFV: ${iosInfo.identifierForVendor}');
        print('Device Model: ${iosInfo.model}');
        // Add more iOS-specific properties as needed
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
class userLocation{
  userLocation();
  var address;
  String? position;

  Future<void> updatePosition() async{
    Position pos=await determinePosition();
    List pm= await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (pm.isNotEmpty) {
      final Placemark firstPlacemark = pm.first;
      final String administrativeArea = firstPlacemark.administrativeArea ?? '';
      final String subAdministrativeArea = firstPlacemark.subAdministrativeArea ?? '';
      final String country = firstPlacemark.country ?? '';

      print('Administrative Area: $administrativeArea');
      print('Subadministrative Area: $subAdministrativeArea');
      print('Country: $country');
    }




  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future <void> _userPosition() async{
    updatePosition();
    position= address;

  }



}