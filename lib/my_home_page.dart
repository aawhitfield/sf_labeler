import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sf_labeler/onboarding_content.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      body: Stack(
        children: [
          Center(
            // from https://lakshydeep-14.medium.com/how-to-use-expanded-or-spacer-inside-listview-or-singlechildscrollview-4056728f1df9
            child: CustomScrollView(
              slivers: <Widget>[
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: (context.isPortrait)
                      ? Column(
                          mainAxisAlignment: context.isPortrait
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.start,
                          children: onBoardingContent(context),
                        )
                      : Row(
                          children: onBoardingContent(context),
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
