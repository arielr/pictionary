import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  static double height = 500;
  static double width = 340;

  WordCard({Key? key, required this.word, this.textStyle}) : super(key: key);
  String word;
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: WordCard.height,
        width: WordCard.width,
        child: Card(
          child: _getWord(context),
        ),
      ),
    );
  }

  Widget _getWord(BuildContext context) {
    var style =
        textStyle == null ? Theme.of(context).textTheme.headline1 : textStyle;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
          children: word
              .trim()
              .split(" ")
              .map((e) => Text(e, style: style))
              .toList()),
    );
  }
}
