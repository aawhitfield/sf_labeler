import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:sf_labeler/models/sales_force_contact.dart';

class SalesForceAPI {
  static Future<List<SalesForceContact>> getContacts(String accessToken) async {
    final response = await http.get(
      Uri.parse(
          'https://brotherhackathon-dev-ed.my.salesforce.com/services/data/v42.0/query/?q=SELECT+id,PhotoUrl,name,MailingStreet,MailingCity,MailingState,MailingPostalCode+from+Contact'),
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
}
