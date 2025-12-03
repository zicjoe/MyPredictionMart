// lib/canton_service.dart
//
// Tiny fake service that *simulates* talking to Canton.
// Later we will replace the internals with real HTTP calls.

import 'dart:async';
import 'package:flutter/foundation.dart';

import 'market.dart';

class CantonService {
  CantonService._internal();

  static final CantonService instance = CantonService._internal();

  /// Simulate placing a bet on the Canton ledger.
  Future<void> placeBet({
    required Market market,
    required String side, // 'yes' or 'no'
    required double stake,
  }) async {
    // Simulate network/ledger latency
    await Future.delayed(const Duration(seconds: 1));

    // For now just log it to console so we see something.
    debugPrint(
      '[CantonService] DEMO placeBet -> '
      'marketId=${market.id}, side=$side, stake=$stake',
    );

    // If you want to simulate a failure sometimes, you could throw.
    // For now we always succeed.
  }
}