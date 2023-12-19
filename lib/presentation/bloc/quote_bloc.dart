import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:my_classroom_app/data/provider/quote_provider.dart';
import 'package:my_classroom_app/data/repositories/quote_repository.dart';
import 'package:my_classroom_app/domain/quote.dart';


class QuoteBloc {
  final _quoteProvider = QuoteProvider(QuoteRepository());
  final _quoteStream = StreamController<Quote>.broadcast();

  Stream<Quote> get quoteStream => _quoteStream.stream;

  Future<void> getQuote() async {
    try {
      final quote = await _quoteProvider.getQuote();
      _quoteStream.add(quote);
    } on Exception catch (e) {
      _quoteStream.addError(e);
    }
  }

  void dispose() {
    _quoteStream.close();
  }
}
