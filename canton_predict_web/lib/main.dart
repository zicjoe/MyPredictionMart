import 'package:flutter/material.dart';
import 'market.dart';
import 'market_detail_page.dart';

void main() {
  runApp(const CantonPredictApp());
}

class CantonPredictApp extends StatelessWidget {
  const CantonPredictApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canton Predict',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const MarketsHomePage(),
    );
  }
}

class MarketsHomePage extends StatelessWidget {
  const MarketsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final markets = dummyMarkets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canton Predict – Markets'),
      ),
      body: ListView.builder(
        itemCount: markets.length,
        itemBuilder: (context, index) {
          final market = markets[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(market.question),
              subtitle: Text(
                'YES: ${market.yesLabel}\nNO: ${market.noLabel}\nStatus: ${market.statusText}',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MarketDetailPage(market: market),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}