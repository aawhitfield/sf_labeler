import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sf_labeler/contacts/contacts_list_body.dart';
import 'package:sf_labeler/contacts/is_printing_dialog.dart';
import 'package:sf_labeler/models/sales_force_api.dart';
import 'package:sf_labeler/models/sales_force_authorization.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/print_api.dart';
import 'package:sf_labeler/providers.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList(this.salesForceAuthorization, {Key? key})
      : super(key: key);

  final SalesForceAuthorization salesForceAuthorization;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<SalesForceContact> filteredContacts = <SalesForceContact>[];
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              ref.read(selectedProvider).updateIsPrinting(true);
              showDialog(
                barrierDismissible: false,
                context: context, builder: (context) => const IsPrintingDialog());
              final List<SalesForceContact> selectedContacts =
                  ref.read(selectedProvider).toBePrinted;
              for (SalesForceContact contact in selectedContacts) {
                await PrintAPI.printContact(context, contact);
              }
              ref.read(selectedProvider).clearPrint();
              ref.read(selectedProvider).updateIsPrinting(false);
            },
            child: const Icon(Icons.print),
          ),
          body: Center(
            child: FutureBuilder<List<SalesForceContact>>(
              future: SalesForceAPI.getContacts(
                  salesForceAuthorization.accessToken),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == null) {
                    return const Text('No data');
                  } else {
                    // get the contacts from the snapshot
                    final List<SalesForceContact> contacts =
                        List.from(snapshot.data!);

                    // create a list to filter the contacts
                    filteredContacts = List.from(contacts);

                    // sort the contacts by name
                    filteredContacts
                        .sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
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
