import 'package:flutter/material.dart';
import 'package:sf_labeler/contacts/contacts_list_body.dart';
import 'package:sf_labeler/models/sales_force_api.dart';
import 'package:sf_labeler/models/sales_force_authorization.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class ContactsList extends StatelessWidget {
  const ContactsList(this.salesForceAuthorization, {Key? key})
      : super(key: key);

  final SalesForceAuthorization salesForceAuthorization;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: FutureBuilder<List<SalesForceContact>>(
          future:
              SalesForceAPI.getContacts(salesForceAuthorization.accessToken),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return const Text('No data');
              } else {

                // get the contacts from the snapshot
                final List<SalesForceContact> contacts =
                    List.from(snapshot.data!);

                // create a list to filter the contacts
                List<SalesForceContact> filteredContacts = List.from(contacts);

                // sort the contacts by name
                filteredContacts.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

                return ContactsListBody(filteredContacts);
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      )),
    );
  }
}
