import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest:
        URLRequest(url: Uri.parse("https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9riCAn8HHkYUeNXLeHjXdlW6ncpfGaKj4DNJysxBFIV.D.EavXpNaBy9MdAebmTZgqm9OkzKBC0n0HSfW&redirect_uri=https://us-central1-sf-labeler.cloudfunctions.net/oauth")),
      ),
    );
  }
}
