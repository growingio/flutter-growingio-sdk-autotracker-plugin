import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:growingio_sdk_autotracker/growingio_sdk_autotracker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _growingioSdkAutotrackerPlugin = GrowingioSdkAutotracker();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _growingioSdkAutotrackerPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gio = GrowingioSdkAutotracker();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            ElevatedButton(
              child: const Text("startWithConfiguration"), 
              onPressed: () {
                gio.startWithConfiguration(
                  projectId: "1234567890", 
                  dataCollectionServerHost: "https://run.mocky.io/v3/08999138-a180-431d-a136-051f3c6bd306", 
                  dataSourceId: "1234567890", 
                  debugEnabled: true);
              }
            ),
            ElevatedButton(
              child: const Text("trackCustomEvent"), 
              onPressed: () {
                gio.trackCustomEvent(eventName: "CSTM");
              }
            ),
            ElevatedButton(
              child: const Text("trackCustomEventWithAttributes"), 
              onPressed: () {
                gio.trackCustomEvent(eventName: "CSTMWithAttr", attributes: {"key" : "value"});
              }
            ),
          ],
        )
      ),
    );
  }
}
