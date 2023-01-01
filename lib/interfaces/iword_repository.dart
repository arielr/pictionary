import '../model/category_data.dart';

abstract class IWordsRepository {
  Future<IWordsRepository> init();
  Future<List<CategoryData>> getAllCategories();
  Future<List<String>> getSelectedCategories();
  Future<List<String>> getWords({required List<String> categories});
  Future saveSelectedCategories(List<String> categories);
}
