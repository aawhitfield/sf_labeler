import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:sf_labeler/authorization.dart';
import 'package:sf_labeler/my_home_page.dart';
import 'package:sf_labeler/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  // from https://appainter.dev/#/
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(ProviderScope(child: MyApp(theme: theme)));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // updated method as of v1.17.1 of Flutter to close soft keyboard
      // by tapping in "blank" space
      // from https://stackoverflow.com/a/61986983/4333051
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: GetMaterialApp(
        title: 'SF Labeler',
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            SharedPreferences prefs = snapshot.data!;
            bool isFirstRun = prefs.getBool(SharedPreferencesKeys.keyIsFirstRun.name) ?? true;
            if(isFirstRun) {
              prefs.setBool(SharedPreferencesKeys.keyIsFirstRun.name, false);
              return const MyHomePage(title: 'SF Labeler');
            }
    
            return const Authorization();
          }
        ),
      ),
    );
  }
}