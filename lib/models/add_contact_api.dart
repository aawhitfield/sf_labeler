import 'dart:io';

import 'package:air_brother/air_brother.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sf_labeler/contacts/add_contact.dart';
import 'package:sf_labeler/contacts/is_analyzing_dialog.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/models/scan_api.dart';
import 'package:sf_labeler/providers.dart';

class AddContactAPI {
  static Future<void> fromCamera(BuildContext context) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      Navigator.of(context).pop();
      File imageFile = File(image.path);
      SalesForceContact contact = await showDialog(
          context: context, builder: (context) => IsAnalyzingDialog(imageFile));
      Get.to(() => AddContact(contact: contact));
    } else {
      Navigator.of(context).pop();
    }
  }

  static Future<JobState?> fromScanner(
      BuildContext context, WidgetRef ref) async {
    List<Connector> _fetchDevices = await AirBrother.getNetworkDevices(5000);

    // this is the list where the paths for the scanned files will be placed
    List<String> outScannedPaths = [];

    if (_fetchDevices.isEmpty) {
      Fluttertoast.showToast(msg: 'No Scanners Found');
      return null;
    } else {
      // from https://pub.dev/packages/air_brother/example
      Connector connector = _fetchDevices.first;
      ScanParameters scanParams = ScanParameters();
      scanParams.autoDocumentSizeScan = true;
      scanParams.documentSize = MediaSize.BusinessCardLandscape;
      ref.read(scanProvider).updateStatus(ScanStatus.scanning);
      JobState jobState =
          await connector.performScan(scanParams, outScannedPaths);

      ref.read(scanProvider).updateScannedPaths(outScannedPaths);
      return jobState;
    }
  }
}
