import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sf_labeler/models/sales_force_authorization.dart';
import 'package:sf_labeler/models/scan_api.dart';
import 'package:sf_labeler/models/selected_contact.dart';

final selectedProvider = ChangeNotifierProvider<SelectedContact>(
  (ref) => SelectedContact(),
);

final authorizationProvider = ChangeNotifierProvider<SalesForceAuthorization>(
  (ref) => SalesForceAuthorization(accessToken: '', instanceUrl: '', issuedAt: 0, scope: '', signature: '', tokenType: ''),
);

final scanProvider = ChangeNotifierProvider<ScanApi>(
  (ref) => ScanApi(),
);