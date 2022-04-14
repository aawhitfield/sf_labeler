import 'package:flutter/material.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class ContactDetails extends StatelessWidget {
  final SalesForceContact contact;

  const ContactDetails(this.contact, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(contact.name ?? ''),),
    );
  }
}
