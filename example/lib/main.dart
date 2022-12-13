import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:growingio_sdk_autotracker/growingio_sdk_autotracker.dart';
import 'package:growingio_sdk_autotracker_example/trackTimerPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final gio = GrowingioSdkAutotracker();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GrowingIO Flutter Plugin'),
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
                  // urlScheme: "growing.xxxxx",
                  debugEnabled: true,
                  // dataCollectionEnabled: true,
                  // idMappingEnabled: true,
                  // encryptEnabled: true,
                  // cellularDataLimit: 10,
                  // dataUploadInterval: 15,
                  // sessionInterval: 20,
                  // excludeEvent: growingFilterEventValues[GrowingFilterEvent.clickChangeSubmit],
                  // ignoreField: growingIgnoreFieldValues[GrowingIgnoreField.networkState],
                  );
              }
            ),
            ElevatedButton(
              child: const Text("enableDataCollect"), 
              onPressed: () {
                gio.setDataCollectionEnabled(true);
              }
            ),
            ElevatedButton(
              child: const Text("disableDataCollect"), 
              onPressed: () {
                gio.setDataCollectionEnabled(false);
              }
            ),
            ElevatedButton(
              child: const Text("setLoginUserId"), 
              onPressed: () {
                gio.setLoginUserId(userId: "12345");
              }
            ),
            ElevatedButton(
              child: const Text("setLoginUserIdAndUserKey"), 
              onPressed: () {
                gio.setLoginUserId(userId: "54321", userKey: "iPhone");
              }
            ),
            ElevatedButton(
              child: const Text("cleanLoginUserId"), 
              onPressed: () {
                gio.cleanLoginUserId();
              }
            ),
            ElevatedButton(
              child: const Text("setLocation"), 
              onPressed: () {
                gio.setLocation(latitude: 30.12345, longitude: 120.12345);
              }
            ),
            ElevatedButton(
              child: const Text("cleanLocation"), 
              onPressed: () {
                gio.cleanLocation();
              }
            ),
            ElevatedButton(
              child: const Text("setLoginUserAttributes"), 
              onPressed: () {
                gio.setLoginUserAttributes(attributes: {"key" : "value"});
              }
            ),
            const GetDeviceIdRow(),
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
            Builder(builder: (context) =>
              ElevatedButton(
                child: const Text("trackTimer"), 
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TrackTimerPage()));
                }
              ),
            ),
          ],
        )
      ),
    );
  }
}

class _GetDeviceIdRowState extends State<GetDeviceIdRow> {
  String? deviceId;

  void _getDeviceId() async {
    String curDeviceId = await GrowingioSdkAutotracker().getDeviceId() ?? "";
    setState(() {
      deviceId = curDeviceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _getDeviceId,
      child: deviceId == null ? const Text("getDeviceId") : Text(deviceId!)
    );
  }
}

class GetDeviceIdRow extends StatefulWidget {
  const GetDeviceIdRow({super.key});

  @override
  State<GetDeviceIdRow> createState() => _GetDeviceIdRowState();
}