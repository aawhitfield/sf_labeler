import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sf_labeler/models/selected_contact.dart';

final selectedProvider = ChangeNotifierProvider<SelectedContact>(
  (ref) => SelectedContact(),
);
