import 'package:flutter/material.dart';
import 'package:my_classroom_app/domain/quote.dart';
import 'package:my_classroom_app/presentation/bloc/quote_bloc.dart';

class QuoteDisplay extends StatefulWidget {
  @override
  _QuoteDisplayState createState() => _QuoteDisplayState();
}

class _QuoteDisplayState extends State<QuoteDisplay> {
  final quoteBloc = QuoteBloc();

  @override
  void initState() {
    super.initState();
    quoteBloc.getQuote();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Quote>(
      stream: quoteBloc.quoteStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            "“${snapshot.data!.content}”\n\n - ${snapshot.data!.author}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  void dispose() {
    quoteBloc.dispose();
    super.dispose();
  }
}
