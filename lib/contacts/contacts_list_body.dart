import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sf_labeler/contacts/add_contact_picker.dart';
import 'package:sf_labeler/contacts/contacts_list_tile.dart';
import 'package:sf_labeler/models/sales_force_api.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/providers.dart';

class ContactsListBody extends ConsumerStatefulWidget {
  const ContactsListBody(this.contacts, {Key? key}) : super(key: key);

  final List<SalesForceContact> contacts;

  @override
  _ContactsListBodyState createState() => _ContactsListBodyState();
}

class _ContactsListBodyState extends ConsumerState<ContactsListBody> {
  List<SalesForceContact> filteredContacts = <SalesForceContact>[];
  final TextEditingController _searchController = TextEditingController();
  // list to store the state of which listtiles are selected

  @override
  void initState() {
    filteredContacts = List.from(widget.contacts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Contacts',
                    style: Theme.of(context).textTheme.headline3),
              )),

          // TextField with search icon and rounded border and a clear button
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              // rounded corners with a radius of 16
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFD1DDF5),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  // hint text = 'Name'
                  hintText: 'Name',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        filteredContacts = List.from(widget.contacts);
                      });
                    },
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                // filter the filteredContacts list by the text in the text field
                onChanged: (text) {
                  setState(() {
                    filteredContacts = widget.contacts
                        .where((contact) =>
                            contact.name
                                ?.toLowerCase()
                                .contains(text.toLowerCase()) ??
                            false)
                        .toList();
                  });
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Tap to mark a contact for printing, then press print to print selected contacts.'
              '\nLong press a contact to edit/delete.',
              style: Theme.of(context).textTheme.caption,
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: OutlinedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                onPressed: () async {
                  await showCupertinoModalPopup(
                      context: context,
                      builder: (context) => const AddContactPicker());
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Add Contact',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                String accessToken =
                    ref.read(authorizationProvider).accessToken;
                return SalesForceAPI.getContacts(accessToken).then((value) => {
                      setState(() {
                        _searchController.clear();
                        filteredContacts = value;
                        // sort the contacts by name
                        filteredContacts.sort(
                            (a, b) => (a.name ?? '').compareTo(b.name ?? ''));
                      })
                    });
              },
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    bool isSelected = ref
                        .watch(selectedProvider)
                        .toBePrinted
                        .contains(filteredContacts[index]);

                    return ContactsListTile(
                      contact: filteredContacts[index],
                      isSelected: isSelected,
                      onTap: () {
                        if (isSelected) {
                          ref
                              .read(selectedProvider)
                              .removeFromPrint(filteredContacts[index]);
                        } else {
                          ref
                              .read(selectedProvider)
                              .addToPrint(filteredContacts[index]);
                        }
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
