import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pictionary2/model/settings_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountdownWidget extends StatefulWidget {
  final double size = 120;
  Function onTimeout = () {};

  CountdownWidget(Function onTimeout) {
    this.onTimeout = onTimeout;
  }

  @override
  State<StatefulWidget> createState() {
    return _CountdownWidget();
  }
}

class _CountdownWidget extends State<CountdownWidget>
    with TickerProviderStateMixin {
  Timer? countdownTimer;
  Duration currentTimeout =
      Duration(seconds: SettingsData.globalSettings.timeoutSeconds);
  Duration originalTimeout =
      Duration(seconds: SettingsData.globalSettings.timeoutSeconds);
  bool isTimeout = false;

  _CountdownWidget() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  @override
  void initState() {
    super.initState();
  }

  void setCountDown() {
    if (!mounted) return;
    setState(() {
      final seconds = currentTimeout.inSeconds - 1;
      if (seconds < 0 && !isTimeout) {
        isTimeout = true;
        widget.onTimeout();
      }

      currentTimeout = Duration(seconds: seconds);
    });
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    countdownTimer = null;
    super.dispose();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ss'),
          content: Text("Pause time"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Center(
        child: GestureDetector(
          onTap: () => _dialogBuilder(context),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: (currentTimeout.inSeconds) / originalTimeout.inSeconds,
              semanticsLabel: 'Circular progress indicator',
            ),
          ),
        ),
      ),
      FittedBox(
        fit: BoxFit.fill,
        child: Text(currentTimeout.inSeconds.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3?.copyWith()),
      )
    ]);
  }
}
