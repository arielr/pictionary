import '../model/category_data.dart';

abstract class IWordsRepository {
  Future<IWordsRepository> init();
  Future<List<CategoryData>> getAllCategories();
  Future<List<String>> getSelectedCategories();
  Future<List<String>> getWords({required String categoryName});
  Future saveSelectedCategories(List<String> categories);
}
