import 'package:flutter/cupertino.dart';

enum ScanStatus {
  initial,
  searching,
  scanning,
  done,
}

class ScanApi extends ChangeNotifier {
  ScanStatus status;

  ScanApi({this.status = ScanStatus.initial});

  String get animationUrl {
    switch (status) {
      case ScanStatus.initial:
        return 'assets/animations/insert.json';
      case ScanStatus.searching:
        return 'assets/animations/radar.json';
      case ScanStatus.scanning:
        return 'assets/animations/scan.json';
      case ScanStatus.done:
        return 'assets/images/scan_done.gif';
    }
  }

  String get statusText {
    switch (status) {
      case ScanStatus.initial:
        return 'Place business card on the scanner. Connect to printer via WiFi.';
      case ScanStatus.searching:
        return 'Searching for scanners...';
      case ScanStatus.scanning:
        return 'Scanning business card...';
      case ScanStatus.done:
        return 'Done';
    }
  }

  void updateStatus(ScanStatus status) {
    this.status = status;
    notifyListeners();
  }
}
