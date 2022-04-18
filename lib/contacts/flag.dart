import 'package:flutter/material.dart';
import 'package:sf_labeler/models/countries.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/models/states.dart';

class Flag extends StatelessWidget {
  const Flag(this.contact, {Key? key}) : super(key: key);

  final SalesForceContact contact;

  @override
  Widget build(BuildContext context) {
    String? state;
    String? country;
    if (contact.mailingState != null) {
      state = USStates.processState(contact.mailingState!);
    }

    // try and parse out the state if it *is* null
    else if (contact.mailingState == null && contact.mailingStreet != null) {
      // try to parse out the state from the street
      List<String> addressParts = contact.mailingStreet!.split(',');
      // if there is a street and a state, then we can parse out the state
      if (addressParts.length == 2) {
        // now we need to check if there is a ZIP code attached
        List<String> stateZipParts = addressParts[1].split(' ');
        if (stateZipParts.length > 2) {
          // if there is a zip code, then we can parse out the state
          // there is a space in *front* of the state so the array looks like: [, NY, 12345]
          state = USStates.processState(stateZipParts[1]);
        }
      } // if there is a suite or an apartment number, then there might be an extra comma, so we want to split that out
      else if (addressParts.length >= 3) {
        // now we need to check if there is a ZIP code attached
        List<String> stateZipParts = addressParts[2].split(' ');
        if (stateZipParts.length > 2) {
          // if there is a zip code, then we can parse out the state
          // there is a space in *front* of the state so the array looks like: [, NY, 12345]
          state = USStates.processState(stateZipParts[1]);
        }
      }

      // finally, it might be another country if state is still null
      // check and see if the last word (or two) is a country
      if (state == null) {
        // check last word
        String lastAddressPart = addressParts.last;
        // countries have a new line character preceeding the country name
        String possibleCountry = lastAddressPart.split('\n').last;
        if (Countries.isCountry(possibleCountry)) {
          country = possibleCountry;

          // convert to country code
          country = Countries.getCountryCode(country);
        }
      }
    }

    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 36,
      backgroundImage: (state != null)
          ? NetworkImage(
              'https://cdn.civil.services/us-states/flags/$state-small.png')
          : (country != null && country.length == 2)
              ? NetworkImage('https://flagcdn.com/84x63/$country.png')
              : null,
    );
  }
}
