// lib/market_service.dart

import 'market.dart';

class MarketService {
  // Later this will call Canton JSON API.
  // For now it just returns the dummy list after a short delay.
  Future<List<Market>> loadMarkets() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return dummyMarkets;
  }
}

// Global instance to use in the app.
final MarketService marketService = MarketService();