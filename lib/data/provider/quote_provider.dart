import 'package:my_classroom_app/data/repositories/quote_repository.dart';
import 'package:my_classroom_app/domain/quote.dart';

class QuoteProvider {
  final QuoteRepository _repository;

  QuoteProvider(this._repository);

  Future<Quote> getQuote() async {
    return await _repository.getQuote();
  }
}
