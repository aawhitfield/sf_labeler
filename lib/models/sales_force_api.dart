import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sf_labeler/models/business_card.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class SalesForceAPI {
  static Future<List<SalesForceContact>> getContacts(String accessToken) async {
    final response = await http.get(
      Uri.parse(
          'https://brotherhackathon-dev-ed.my.salesforce.com/services/data/v42.0/query/?q=SELECT+id,PhotoUrl,name,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode+from+Contact'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('records')) {
        final contacts = jsonResponse['records']
            .map<SalesForceContact>(
                (contact) => SalesForceContact.fromMap(contact))
            .toList();
        return contacts;
      } else {
        throw Exception('No contacts found');
      }
    } else {
      throw Exception('Failed to load contacts');
    }
  }

////////////////////////////////////////////////////////////////////////////////
  static Future<void> deleteContact(
      String accessToken, String contactId) async {
    final response = await http.delete(
      Uri.parse(
          'https://brotherhackathon-dev-ed.my.salesforce.com/services/data/v54.0/sobjects/Contact/$contactId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    } else {
      debugPrint('${response.statusCode} ${response.body}');
      throw Exception('Failed to delete contact');
    }
  }

////////////////////////////////////////////////////////////////////////////////
  static Future<void> editContact(
      String accessToken, String contactId, String data) async {
    final response = await http.patch(
      Uri.parse(
          'https://brotherhackathon-dev-ed.my.salesforce.com/services/data/v54.0/sobjects/Contact/$contactId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: data,
    );
    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    } else {
      debugPrint('${response.statusCode} ${response.body}');
      throw Exception('Failed to edit contact');
    }
  }

////////////////////////////////////////////////////////////////////////////////
  static Future<void> createContact(String accessToken, String data) async {
    final response = await http.post(
      Uri.parse(
          'https://brotherhackathon-dev-ed.my.salesforce.com/services/data/v54.0/sobjects/Contact'),
      headers: {
        "referenceId": "NewContact",
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: data,
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    } else {
      debugPrint('${response.statusCode} ${response.body}');
      throw Exception('Failed to create contact');
    }
  }

////////////////////////////////////////////////////////////////////////////////
  static SalesForceContact convertBusinessCardToContact(BusinessCard card) {
    String street = '';
    String city = '';
    String state = '';
    String zip = '';

    // split an address like "123 Main St, Anytown, CA 12345" into "123 Main St", "Anytown", "CA 12345"
    List<String> addressParts = (card.addresses != null &&
            card.addresses!.isNotEmpty &&
            card.addresses!.first.fullAddress != null)
        ? card.addresses!.first.fullAddress!.split(',')
        : <String>[];

    if (addressParts.length > 1) {
      String last = addressParts.last;
      last = last.trim();
      if (last.contains(' ')) {
        // then it is like CA 12345
        List<String> zipParts = last.split(' ');
        if (zipParts.length > 1) {
          if (zipParts[0].length == 2) {
            state = zipParts[0];
          }

          if (zipParts[1].length == 5 && int.tryParse(zipParts[1]) != null) {
            zip = zipParts[1];
          }

          city = addressParts.first;
        }
      } else if (last.length == 5 && int.tryParse(last) != null) {
        zip = last;
        street = addressParts.first;
        if (addressParts.length > 2 && addressParts[2].length == 2) {
          city = addressParts[1];
          state = addressParts[2];
        } else if (addressParts.length > 1 && addressParts[1].length == 2) {
          state = addressParts[1];
        }
      } else {
        street = card.addresses!.first.fullAddress!;
      }
    } else {
      // if no commas exist
      List<String> addressPartsFromSpaces =
          card.addresses!.first.fullAddress!.split(' ');
      if (addressPartsFromSpaces.length > 1) {
        // try to filter out zip at end and the state and then the city, the rest is the street
        String last = addressPartsFromSpaces.last;
        if (last.length == 5 &&
            int.tryParse(last) != null &&
            addressPartsFromSpaces.length > 3) {
          zip = last;
          state = addressPartsFromSpaces[addressPartsFromSpaces.length - 2];
          city = addressPartsFromSpaces[addressPartsFromSpaces.length - 3];
          for (int i = 0; i < addressPartsFromSpaces.length - 3; i++) {
            street += addressPartsFromSpaces[i] + ' ';
          }
        } else {
          street = card.addresses!.first.fullAddress!;
        }
      } else {
        street = card.addresses!.first.fullAddress!;
      }
    }

    SalesForceContact contact = SalesForceContact(
      firstName: card.firstName,
      lastName: card.lastName,
      mailingStreet: street,
      mailingCity: city,
      mailingState: state,
      mailingPostalCode: zip,
    );

    return contact;
  }
}
