import 'package:flutter/material.dart';
import 'package:growingio_sdk_autotracker/growingio_sdk_autotracker.dart';
import 'dart:math';

class TrackTimerPage extends StatefulWidget {
  const TrackTimerPage({super.key});

  @override
  State<TrackTimerPage> createState() => _TrackTimerPageState();
}

class _TrackTimerPageState extends State<TrackTimerPage> {
  final gio = GrowingioSdkAutotracker();
  String defaultEventName = "eventName";
  String? eventName;
  List<String> timerIds = [];
  List<List<String>> attributesList = [];

  void _trackTimerStart() async {    
    FocusManager.instance.primaryFocus?.unfocus();

    String? e = eventName;
    if (e == null || e.isEmpty) {
      e = defaultEventName;
    }
    String timerId = await gio.trackTimerStart(eventName: e) ?? "";
    setState(() {
      timerIds.add(timerId);
    });
  }

  void _trackTimerEnd(int index) {
    Map<String, String> attributes = {};
    for (List<String> keyValue in attributesList) {
      attributes[keyValue[0]] = keyValue[1];
    }
    if (attributes.isNotEmpty) {
      gio.trackTimerEnd(timerId: timerIds[index], attributes: attributes);
    } else {
      gio.trackTimerEnd(timerId: timerIds[index]);
    }
    setState(() {
      timerIds.remove(timerIds[index]);
    });
  }

  void _removeTimer(int index) {
    gio.removeTimer(timerId: timerIds[index]);
    setState(() { 
      timerIds.remove(timerIds[index]);
    });
  }

  void _removeAttribute(int index) {
    setState(() {
      attributesList.removeAt(index);
    });
  }

  void _addRandomAttribute() {
    String key = generateRandomString(5);
    String value = generateRandomString(5);
    setState(() {
      attributesList.add([key, value]);
    });
  }

  String generateRandomString(int length) {
    const availableChars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(length, (index) => availableChars[Random().nextInt(availableChars.length)]).join();
  }

  SizedBox _buttonBuilder(String text, Function() onPressed) {
    return SizedBox(
      width: 55,
      child: Container(
        padding: const EdgeInsets.all(2),
        child:ElevatedButton(
          style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(3))),
          onPressed: onPressed,
          child: Text(text, style: const TextStyle(fontSize: 12))
        ),
      ),
    );
  }

  Expanded _textFieldBuilder({required bool isKey, required int index}) {
    return Expanded(
      child: SizedBox(
        height: 50, 
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: TextField(
            autocorrect: false, 
            decoration: InputDecoration(
              border: const OutlineInputBorder(), 
              labelText: (isKey ? "key" : "value")),
            controller: TextEditingController()..text = attributesList[index][isKey ? 0 : 1],
            onChanged: (value) {
              attributesList[index][isKey ? 0 : 1] = value;
            },
          )
        )
      )
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          ), 
          title: const Text('Track Timer'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount:timerIds.length + attributesList.length + 3,
          itemBuilder:(BuildContext context, int index) {
            if (index == 0) {
              return TextField(
                autocorrect: false, 
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), 
                  labelText: "set eventName"),
                controller: TextEditingController()..text = eventName ?? defaultEventName,
                onChanged: (value) {
                  eventName = value;
                },
              );
            } else if (index == 1) {
              return ElevatedButton(
                onPressed: _trackTimerStart,
                child: const Text("trackTimerStart"), 
              );
            } else if (index > 1 && index < attributesList.length + 3) {
              if (index == 2) {
                return ElevatedButton(
                  onPressed: _addRandomAttribute,
                  child: const Text("addRandomAttribute"), 
                );
              } else {
                index = index - 3;
                return Row(
                  children: [
                    _textFieldBuilder(isKey: true, index: index),
                    _textFieldBuilder(isKey: false, index: index),
                    _buttonBuilder("remove", () {
                      _removeAttribute(index);
                    }),
                  ]
                );
              }
            } else {
              index = index - attributesList.length - 3;
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      timerIds[index],
                      maxLines: 2,
                    ),
                  ),
                  _buttonBuilder("pause", () {
                    gio.trackTimerPause(timerId: timerIds[index]);
                  }),
                  _buttonBuilder("resume", () {
                    gio.trackTimerResume(timerId: timerIds[index]);
                  }),
                  _buttonBuilder("end", () {
                    _trackTimerEnd(index);
                  }),
                  _buttonBuilder("remove", () {
                    _removeTimer(index);
                  }),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}