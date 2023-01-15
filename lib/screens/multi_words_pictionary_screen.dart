import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictionary2/widgets/word_card.dart';
import '../interfaces/iword_repository.dart';
import '../model/settings_data.dart';
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
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _wordsRepository.init().then((repository) => {
          repository.getSelectedCategories().then((categories) => repository
              .getWords(categories: categories)
              .then((value) => {_words.addAll(value)}))
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<void>(
            future: _initializationFuture,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              Widget widget;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  {
                    widget = Center(
                        child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ));
                  }
                  break;

                case ConnectionState.done:
                  {
                    var children = getChildren();
                    widget = Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: children));
                  }
                  break;

                default:
                  {
                    widget = Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          )
                        ]));
                  }
                  break;
              }

              return widget;
            }));
  }

  List<Widget> getChildren() {
    String words = _words.isEmpty ? "empty" : _words.last;
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
                    key: Key(words),
                    child: WordCard(word: words),
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
          child: SettingsData.globalSettings.enableTime
              ? CountdownWidget(() {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TimeupScreen(_accepted, _rejected)),
                    );
                  });
                })
              : Container(),
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
          if (_words.isEmpty) {
            _words = _accepted + _rejected;
            _words.shuffle();
          }
        });
      },
    );
  }
}
