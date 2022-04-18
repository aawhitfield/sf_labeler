import 'package:flutter/material.dart';
import 'package:sf_labeler/contacts/contacts_list_tile.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class ContactsListBody extends StatefulWidget {
  const ContactsListBody(this.contacts, {Key? key}) : super(key: key);

  final List<SalesForceContact> contacts;

  @override
  _ContactsListBodyState createState() => _ContactsListBodyState();
}

class _ContactsListBodyState extends State<ContactsListBody> {
  List<SalesForceContact> filteredContacts = <SalesForceContact>[];
  final TextEditingController _searchController = TextEditingController();

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

          Expanded(
            child: ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  return ContactsListTile(contact: filteredContacts[index]);
                }),
          ),
        ],
      ),
    );
  }
}
