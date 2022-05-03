import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sf_labeler/contacts/contacts_list.dart';
import 'package:sf_labeler/contacts/is_updating_dialog.dart';
import 'package:sf_labeler/models/sales_force_api.dart';
import 'package:sf_labeler/models/sales_force_authorization.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/providers.dart';

class ContactDetails extends ConsumerStatefulWidget {
  final SalesForceContact contact;

  const ContactDetails(this.contact, {Key? key}) : super(key: key);

  @override
  ConsumerState<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends ConsumerState<ContactDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  @override
  void initState() {
    if (widget.contact.name != null) {
      _nameController.text = widget.contact.name!;
    }
    if (widget.contact.mailingStreet != null) {
      _streetController.text = widget.contact.mailingStreet!;
    }
    if (widget.contact.mailingCity != null) {
      _cityController.text = widget.contact.mailingCity!;
    }
    if (widget.contact.mailingState != null) {
      _stateController.text = widget.contact.mailingState!;
    }
    if (widget.contact.mailingPostalCode != null) {
      _zipController.text = widget.contact.mailingPostalCode!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String accessToken = ref.read(authorizationProvider).accessToken;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                                color: Theme.of(context).primaryColor)),
                        Expanded(child: Container(color: Colors.white)),
                      ],
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.2,
                      backgroundImage: (widget.contact.photoUrl != null)
                          ? NetworkImage(
                              'https://brotherhackathon-dev-ed.my.salesforce.com/' +
                                  widget.contact.photoUrl!,
                              headers: {
                                  'Authorization': 'Bearer $accessToken',
                                })
                          : null,
                      backgroundColor: (widget.contact.photoUrl == null)
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.only(top: 1, bottom: 8)),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _streetController,
                  decoration: const InputDecoration(
                      labelText: 'Street',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.only(top: 1, bottom: 8)),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                      labelText: 'City',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.only(top: 1, bottom: 8)),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                      labelText: 'State',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.only(top: 1, bottom: 8)),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _zipController,
                  decoration: const InputDecoration(
                      labelText: 'Zip',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.only(top: 1, bottom: 8)),
                ),
                const SizedBox(height: 64),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton(
                    onPressed: () async {
                      String data = jsonEncode({
                        // "Name": _nameController.text,
                        "MailingStreet": _streetController.text,
                        "MailingCity": _cityController.text,
                        "MailingState": _stateController.text,
                        "MailingPostalCode": _zipController.text,
                      });
                      if (widget.contact.id != null) {
                        showDialog(
                            context: context,
                            builder: (context) => const IsUpdatingDialog());
                        await SalesForceAPI.editContact(
                            accessToken, widget.contact.id!, data);
                      }
                      SalesForceAuthorization salesForceAuthorization =
                          ref.read(authorizationProvider);
                      Get.offAll(() => ContactsList(salesForceAuthorization));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Update Contact',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
