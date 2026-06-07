import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class ApiService {
  static const baseUrl = "https://restcountries.com/v3.1";

  Future<List<Country>> fetchAll() async {
    final res = await http.get(
      Uri.parse("$baseUrl/all?fields=name,capital,currencies"),
    );

    if (res.statusCode != 200) {
      throw Exception("API error (list)");
    }

    final data = jsonDecode(res.body) as List;
    return data.map((e) => Country.fromJson(e)).toList();
  }


  Future<Country> fetchDetails(String name) async {
    final res = await http.get(
      Uri.parse("$baseUrl/name/${Uri.encodeComponent(name)}"),
    );

    if (res.statusCode != 200) {
      throw Exception("API error (details)");
    }

    final data = jsonDecode(res.body);

    if (data is List && data.isNotEmpty) {
      return Country.fromJson(data[0]);
    } else {
      throw Exception("No data available for this country");
    }
  }
}