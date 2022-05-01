import 'package:flutter/cupertino.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class SelectedContact extends ChangeNotifier {
  List<SalesForceContact> toBePrinted = <SalesForceContact>[];
  bool isPrinting = false;

  void addToPrint(SalesForceContact contact) {
    toBePrinted.add(contact);
    notifyListeners();
  }

  void removeFromPrint(SalesForceContact contact) {
    toBePrinted.remove(contact);
    notifyListeners();
  }

  void clearPrint() {
    toBePrinted.clear();
    notifyListeners();
  }

  void updateIsPrinting(bool isPrinting) {
    this.isPrinting = isPrinting;
    notifyListeners();
  }
}
