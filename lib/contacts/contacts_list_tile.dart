import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sf_labeler/contacts/contact_details.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class ContactsListTile extends StatelessWidget {
  const ContactsListTile({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final SalesForceContact contact;

  @override
  Widget build(BuildContext context) {

    String name = contact.name ?? '';
    String street = contact.mailingStreet ?? '';
    String city = contact.mailingCity ?? '';
    String state = contact.mailingState ?? '';
    String zip = contact.mailingPostalCode ?? '';

    String secondLine = (city != '' && state != '')
        ? '$city, $state $zip'
        : '';

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ListTile(
        title: Text(name, style: GoogleFonts.quicksand(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(street, style: GoogleFonts.quicksand(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),),
            Text(secondLine, style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(CupertinoIcons.chevron_forward),
        onTap: () {
          Get.to(
            () => ContactDetails(contact),
            transition: Transition.rightToLeft,
          );
        },
      ),
    );
  }
}
