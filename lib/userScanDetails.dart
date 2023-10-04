
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

}