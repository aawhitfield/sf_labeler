import 'package:flutter/cupertino.dart';

enum ScanStatus {
  initial,
  searching,
  scanning,
  connectToWifi,
  processing,
  done,
}

class ScanApi extends ChangeNotifier {
  ScanStatus status;
  List<String> outScannedPaths;

  ScanApi({this.status = ScanStatus.initial, this.outScannedPaths = const <String>[]});

  String get animationUrl {
    switch (status) {
      case ScanStatus.initial:
        return 'assets/animations/insert.json';
      case ScanStatus.searching:
        return 'assets/animations/radar.json';
      case ScanStatus.scanning:
        return 'assets/animations/scan.json';
      case ScanStatus.connectToWifi:
        return 'assets/animations/wifi.json';
      case ScanStatus.processing:
        return 'assets/animations/analyze.json';
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
      case ScanStatus.connectToWifi:
        return 'Disconnect from printer WiFi...';
      case ScanStatus.processing:
        return 'Analyzing image...';
      case ScanStatus.done:
        return 'Done';
    }
  }

  void updateStatus(ScanStatus status) {
    this.status = status;
    notifyListeners();
  }

  void updateScannedPaths(List<String> outScannedPaths) {
    this.outScannedPaths = outScannedPaths;
    notifyListeners();
  }
}
