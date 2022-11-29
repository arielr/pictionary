import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictionary2/widgets/word_card.dart';

enum Swipe { left, right, none }

class DragWidget extends StatefulWidget {
  DragWidget({Key? key, required this.word, required this.swipeNotifier})
      : super(key: key);

  final String word;
  ValueNotifier<Swipe> swipeNotifier;

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      axis: Axis.horizontal,
      data: 1,
      dragAnchorStrategy: myPointerDragAnchorStrategy,
      feedback: Center(
        child: ValueListenableBuilder(
            valueListenable: widget.swipeNotifier,
            builder: (context, swipe, _) {
              return WordCard(word: widget.word);
            }),
      ),
      childWhenDragging: Container(
        color: Colors.transparent,
      ),
      child: ValueListenableBuilder(
          valueListenable: widget.swipeNotifier,
          builder: (context, swipe, _) {
            return WordCard(word: widget.word);
          }),
      onDragUpdate: (DragUpdateDetails dragUpdateDetails) {
        if (dragUpdateDetails.delta.dx > 0 &&
            dragUpdateDetails.globalPosition.dx >
                MediaQuery.of(context).size.width / 2) {
          widget.swipeNotifier.value = Swipe.right;
        }
        if (dragUpdateDetails.delta.dx < 0 &&
            dragUpdateDetails.globalPosition.dx <
                MediaQuery.of(context).size.width / 2) {
          widget.swipeNotifier.value = Swipe.left;
        }
      },
      onDragEnd: (drag) {
        widget.swipeNotifier.value = Swipe.none;
      },
    );
  }

  Offset myPointerDragAnchorStrategy(
      Draggable<Object> draggable, BuildContext context, Offset position) {
    return Offset(WordCard.width / 2, WordCard.height / 2);
  }
}
