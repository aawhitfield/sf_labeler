import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sf_labeler/contacts/add_contact.dart';
import 'package:sf_labeler/contacts/is_scanning_dialog.dart';
import 'package:sf_labeler/models/add_contact_api.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class AddContactPicker extends ConsumerWidget {
  const AddContactPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoActionSheet(
      title: const Text(
        'Add Contact',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      message: const Text('How would you like to add the new contact?'),
      actions: [
        CupertinoActionSheetAction(
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(FontAwesomeIcons.penToSquare),
              ),
              Text('Enter Details Manually'),
            ],
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Get.to(() => const AddContact());
          },
        ),
        CupertinoActionSheetAction(
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(FontAwesomeIcons.camera),
              ),
              Text('Scan from Phone Camera'),
            ],
          ),
          onPressed: () async {
            await AddContactAPI.fromCamera(context);
          },
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.of(context).pop();
            SalesForceContact? contact = await showDialog(
                context: context,
                builder: (context) => const IsScanningDialog());
            Get.to(() => AddContact(contact: contact));
          },
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(FontAwesomeIcons.print),
              ),
              Text('Scan with Brother Scanner'),
            ],
          ),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
