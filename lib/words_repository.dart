import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pictionary2/model/category_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'interfaces/iword_repository.dart';

class WordsRepository implements IWordsRepository {
  final String selectedCategories = "SELECTED_CATEGORIES";

  bool isInitialized = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Map<String, List<String>> _map = Map();
  final List<CategoryData> _categoryData = [
    CategoryData("General", Icons.question_answer, "pictionary_words.csv")
  ];

  @override
  Future<List<CategoryData>> getAllCategories() {
    return Future.value(_categoryData);
  }

  @override
  Future<List<String>> getSelectedCategories() {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList(selectedCategories) ?? [];
    });
  }

  @override
  Future<List<String>> getWords({required String categoryName}) {
    return Future.value(_map[categoryName] ?? []);
  }

  @override
  Future<IWordsRepository> init() async {
    List<Future> futures = [];
    if (!isInitialized) {
      futures = _categoryData.map((category) {
        return _loadAsset(category.title, category.resourceName);
      }).toList();
      futures.add(saveSelectedCategories(["General"]));
    }
    await Future.wait(futures).then((value) => isInitialized = true);
    return this;
  }

  @override
  Future saveSelectedCategories(List<String> categories) {
    return _prefs.then((pref) {
      pref.setStringList(selectedCategories, categories);
    });
  }

  Future _loadAsset(String categoryName, String resourceName) {
    return rootBundle
        .loadString('assets/data/${resourceName}')
        .then((fileContent) {
      _map[categoryName] = fileContent.split("\n");
    });
  }
}
