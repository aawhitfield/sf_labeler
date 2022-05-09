import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sf_labeler/contacts/add_contact.dart';
import 'package:sf_labeler/models/covve_api.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class AddContactAPI {
  static Future<void> fromCamera(BuildContext context) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      SalesForceContact contact =
          await CovveAPI.processBusinessCardScan(imageFile);
      Navigator.of(context).pop();
      Get.to(() => AddContact(contact: contact));
    } else {
      Navigator.of(context).pop();
    }
  }
}
