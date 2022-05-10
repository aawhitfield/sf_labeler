import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sf_labeler/contacts/add_contact.dart';
import 'package:sf_labeler/contacts/is_analyzing_dialog.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class AddContactAPI {

  static Future<void> fromCamera(BuildContext context, WidgetRef ref) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      Navigator.of(context).pop();
      File imageFile = File(image.path);
      SalesForceContact contact = await showDialog(context: context, builder: (context) => IsAnalyzingDialog(imageFile));
      Get.to(() => AddContact(contact: contact));
    } else {
      Navigator.of(context).pop();
    }
  }
}
