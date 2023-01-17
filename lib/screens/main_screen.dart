import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictionary2/model/settings_data.dart';
import 'multi_words_pictionary_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          style: style,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsScreen(SettingsData.globalSettings),
                ));
          },
          child: Text("New Game"),
        ),
        Container(
          color: Colors.red,
        )
      ]),
    );
  }
}
