import 'package:ar_navigator/models/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  Address startLocation, endLocation, homeLocation;

  void updateStartLocationAddress(Address startAddress) {
    startLocation = startAddress;
    notifyListeners();
  }

  void updateEndLocationAddress(Address endAddress) {
    endLocation = endAddress;
    notifyListeners();
  }
}
