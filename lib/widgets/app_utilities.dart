import 'package:flutter/widgets.dart';

enum DeviceType {
  Mobile,
  Tablet,
}

class DeviceUtils {
  static DeviceType getDeviceType(BuildContext context) {
    // Get the device width
    var width = MediaQuery.of(context).size.width;

    // Determine device type based on width (adjust as needed)
    if (width > 600) {
      return DeviceType.Tablet;
    } else {
      return DeviceType.Mobile;
    }
  }

  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
