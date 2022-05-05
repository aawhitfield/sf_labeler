import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sf_labeler/contacts/contacts_list.dart';
import 'package:sf_labeler/contacts/is_creating_dialog.dart';
import 'package:sf_labeler/models/sales_force_api.dart';
import 'package:sf_labeler/models/sales_force_authorization.dart';
import 'package:sf_labeler/providers.dart';

class AddContact extends ConsumerStatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  ConsumerState<AddContact> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends ConsumerState<AddContact> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String accessToken = ref.read(authorizationProvider).accessToken;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Add Contact',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
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
                      child: Icon(Icons.person_add,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.2),
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
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.only(top: 1, bottom: 8)),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                      labelText: 'Last Name',
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
                        "FirstName": _firstNameController.text,
                        "LastName": _lastNameController.text,
                        "MailingStreet": _streetController.text,
                        "MailingCity": _cityController.text,
                        "MailingState": _stateController.text,
                        "MailingPostalCode": _zipController.text,
                      });

                      showDialog(
                          context: context,
                          builder: (context) => const IsCreatingDialog());
                      await SalesForceAPI.createContact(accessToken, data);

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
                        'Create Contact',
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
