import 'package:flutter/cupertino.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class SelectedContact extends ChangeNotifier {
  List<SalesForceContact> toBePrinted = <SalesForceContact>[];
  bool isPrinting = false;
  bool isDeleting = false;
  bool isUpdating = false;
  bool isCreating = false;
  bool isAnalyzing = false;

  int sent = 0;
  int total = 100;
  int progress = 0;

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

  void updateIsDeleting(bool isDeleting) {
    this.isDeleting = isDeleting;
    notifyListeners();
  }

  void updateIsUpdating(bool isUpdating) {
    this.isUpdating = isUpdating;
    notifyListeners();
  }

  void updateIsCreating(bool isCreating) {
    this.isCreating = isCreating;
    notifyListeners();
  }

  void updateIsAnalyzing(bool isAnalyzing) {
    this.isAnalyzing = isAnalyzing;
    notifyListeners();
  }

    void updateIsAnalyzingWithoutNotifying(bool isAnalyzing) {
    this.isAnalyzing = isAnalyzing;
  }

  void updateProgress(int sent, int total) {
    this.sent = sent;
    this.total = total;
    progress = ((sent / total) * 100).round();
    notifyListeners();
  }
}
