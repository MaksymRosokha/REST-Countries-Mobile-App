import 'package:hive_ce_flutter/hive_flutter.dart';
import '../models/country.dart';

class LocalDb {
  final box = Hive.box('countries');

  void save(List<Country> list) {
    try {
      final data = list.map((e) => e.toJson()).toList();
      box.put('countries', data);
    } catch (e) {
      print(e);
    }
  }

  List<Country> get() {
    try {
      final data = box.get('countries');
      if (data == null || data is! List) {
        return [];
      }

      final List<Country> loadedCountries = [];
      for (var item in data) {
        if (item is Map) {
          final Map<String, dynamic> castingMap = Map<String, dynamic>.from(item);
          loadedCountries.add(Country.fromJson(castingMap));
        }
      }
      return loadedCountries;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteAll() async {
    await box.clear();
  }

  void deleteOne(String countryName) {
    final currentList = get();
    currentList.removeWhere((c) => c.name == countryName);
    save(currentList);
  }
}