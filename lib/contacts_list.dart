import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sf_labeler/contact_details.dart';
import 'package:sf_labeler/models/sales_force_api.dart';
import 'package:sf_labeler/models/sales_force_authorization.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class ContactsList extends StatelessWidget {
  const ContactsList(this.salesForceAuthorization, {Key? key})
      : super(key: key);

  final SalesForceAuthorization salesForceAuthorization;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder<List<SalesForceContact>>(
        future: SalesForceAPI.getContacts(salesForceAuthorization.accessToken),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  if (snapshot.data == null) {
                    return const Text('No data');
                  } else {
                    String city = snapshot.data![index].mailingCity ?? '';
                    String state = snapshot.data![index].mailingState ?? '';
                    String zip = snapshot.data![index].mailingPostalCode ?? '';

                    String secondLine =
                        (city != '' && state != '') ? '$city, $state $zip' : '';
                    return ListTile(
                      title: Text(snapshot.data![index].name ?? ''),
                      subtitle: Column(
                        children: [
                          Text(snapshot.data![index].mailingStreet ?? ''),
                          Text(secondLine),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () {
                        SalesForceContact contact = snapshot.data![index];
                        Get.to(
                          ContactDetails(contact),
                          transition: Transition.rightToLeft,
                        );
                      },
                    );
                  }
                });
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    ));
  }
}
