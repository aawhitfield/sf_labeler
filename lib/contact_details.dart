import 'package:flutter/material.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/print_api.dart';

class ContactDetails extends StatelessWidget {
  final SalesForceContact contact;

  const ContactDetails(this.contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PrintAPI.printContact(context, contact);
        },
        child: const Icon(
          Icons.print,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(contact.name ?? ''),
            Text(
              contact.mailingStreet ?? '',
              textAlign: TextAlign.center,
            ),
            Text(
                '${contact.mailingCity ?? ''}, ${contact.mailingState ?? ''} ${contact.mailingPostalCode ?? ''}'),
          ],
        ),
      ),
    );
  }
}
