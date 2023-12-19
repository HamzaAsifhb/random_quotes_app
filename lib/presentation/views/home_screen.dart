import 'package:flutter/material.dart';
import 'package:my_classroom_app/presentation/widgets/quote_display.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Quote"),
      ),
      body: Center(
        child: QuoteDisplay(),
      ),
    );
  }
}
