import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictionary2/screens/main_screen.dart';
import 'multi_words_pictionary_screen.dart';

class TimeupScreen extends StatelessWidget {
  List<String> words = [];
  int rightCount = 0;
  int wrongCount = 0;

  TimeupScreen(List<String> rightWords, List<String> wrongWords) {
    words = ["Right"] + rightWords + ["Wrong"] + wrongWords;
    rightCount = rightWords.length;
    wrongCount = wrongWords.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        //    crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text("Time's Up!",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: Colors.red)),
          ),
          SizedBox(
            height: 10,
          ),
          Text("You got ${rightCount} out of ${rightCount + wrongCount}",
              style: Theme.of(context).textTheme.headline5),
          getGridOfWords(context),
          const SizedBox(
            width: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiWordsPictionaryScreen()),
                  );
                },
                child: Text("New Round"),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                child: Text("Menu"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getGridOfWords(BuildContext context) {
    return Center(
      child: Container(
        //width: 150,
        height: 400,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Card(
            //color: Colors.transparent,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: words.length,
              itemBuilder: (_, int index) {
                return ListTile(
                  title: Center(
                      child: (index == 0 || index == rightCount + 1)
                          ? Text(
                              words[index],
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          : Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  words[index],
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
