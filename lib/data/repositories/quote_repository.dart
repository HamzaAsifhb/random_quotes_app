import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_classroom_app/domain/quote.dart';

class QuoteRepository {
  Future<Quote> getQuote() async {
    final response = await http.get(Uri.parse("https://api.quotable.io/random"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Quote(content: data["content"], author: data["author"]);
    } else {
      throw Exception("Failed to fetch quote");
    }
  }
}
