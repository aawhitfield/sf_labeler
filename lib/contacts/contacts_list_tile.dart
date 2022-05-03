import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sf_labeler/contacts/contact_details.dart';
import 'package:sf_labeler/contacts/contacts_list.dart';
import 'package:sf_labeler/contacts/flag.dart';
import 'package:sf_labeler/contacts/is_deleting_dialog.dart';
import 'package:sf_labeler/models/sales_force_api.dart';
import 'package:sf_labeler/models/sales_force_authorization.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/providers.dart';

class ContactsListTile extends ConsumerWidget {
  const ContactsListTile({
    Key? key,
    required this.contact,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  final SalesForceContact contact;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String name = contact.name ?? '';
    String street = contact.mailingStreet ?? '';
    String city = contact.mailingCity ?? '';
    String state = contact.mailingState ?? '';
    String zip = contact.mailingPostalCode ?? '';

    String secondLine = (city != '' && state != '') ? '$city, $state $zip' : '';

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: CupertinoContextMenu(
        actions: <Widget>[
          CupertinoContextMenuAction(
              child: Center(
            child: Text(
              'Options',
              style: Theme.of(context).textTheme.caption,
            ),
          )),
          CupertinoContextMenuAction(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Edit'),
                  Icon(FontAwesomeIcons.penToSquare),
                ],
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              Get.to(() => ContactDetails(contact));
            },
          ),
          CupertinoContextMenuAction(
            isDestructiveAction: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Delete'),
                  Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.destructiveRed,
                  )
                ],
              ),
            ),
            onPressed: () async {
                String accessToken = ref.read(authorizationProvider).accessToken;
                ref.read(selectedProvider).updateIsDeleting(true);
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const IsDeletingDialog());
                  if (contact.id != null) {
                    try {
                      await SalesForceAPI.deleteContact(accessToken, contact.id!);
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }
                ref.read(selectedProvider).updateIsDeleting(false);
              SalesForceAuthorization salesForceAuthorization =
                          ref.read(authorizationProvider);
                      Get.offAll(() => ContactsList(salesForceAuthorization));
            },
          ),
        ],
        child: Material(
          child: SingleChildScrollView(
            child: ListTile(
              title: Text(
                name,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    street,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    secondLine,
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              leading: Flag(contact),
              trailing: (isSelected) ? const Icon(Icons.check) : null,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
