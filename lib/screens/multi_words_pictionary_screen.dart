import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictionary2/widgets/word_card.dart';
import '../interfaces/iword_repository.dart';
import '../widgets/count_down_widget.dart';
import '../widgets/drag_widget.dart';
import '../words_repository.dart';
import 'times_up_screen.dart';

class MultiWordsPictionaryScreen extends StatefulWidget {
  const MultiWordsPictionaryScreen({Key? key}) : super(key: key);

  @override
  State<MultiWordsPictionaryScreen> createState() =>
      _MultiWordsPictionaryScreenState();
}

class _MultiWordsPictionaryScreenState
    extends State<MultiWordsPictionaryScreen> {
  IWordsRepository _wordsRepository = WordsRepository();
  ValueNotifier<Swipe> _swipeNotifier = ValueNotifier(Swipe.none);
  List<String> _words = [];
  List<String> _rejected = [];
  List<String> _accepted = [];

  @override
  void initState() {
    _wordsRepository
        .init()
        .then((repository) => {
              repository
                  .getSelectedCategories()
                  .then((categories) => categories.forEach((category) => {
                        repository
                            .getWords(categoryName: category)
                            .then((value) => {_words.addAll(value)})
                      }))
            })
        .then((value) => setState(() {
              _words = _words;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Center(
            child: orientation == Orientation.portrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getChildren(),
                  )
                : Row(
                    children: getChildren(),
                  ));
      },
    ));
  }

  List<Widget> getChildren() {
    return [
      Expanded(
        flex: 75,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: _swipeNotifier,
              builder: (context, swipe, _) => Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Dismissible(
                    key: Key(_words.last),
                    child: WordCard(word: _words.last),
                    onDismissed: (direction) {
                      (direction == DismissDirection.endToStart
                              ? _rejected
                              : _accepted)
                          .add(_words.last);
                      setState(() {
                        _words.removeLast();
                        _words = _words;
                      });
                    },
                  )
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: createTarget(_accepted),
            ),
            Positioned(
              left: 0,
              child: createTarget(_rejected),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 25,
        child: Center(
          child: CountdownWidget(() {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TimeupScreen(_accepted, _rejected)),
              );
            });
          }),
        ),
      ),
    ];
  }

  Widget createTarget(List<String> resultList) {
    return DragTarget<int>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return IgnorePointer(
          child: Container(
            height: 700.0,
            width: 100.0,
            // color: Colors.red,
          ),
        );
      },
      onAccept: (int index) {
        setState(() {
          resultList.add(_words.last);
          _words.removeLast();
        });
      },
    );
  }
}
