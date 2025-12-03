// lib/market.dart

enum MarketStatus { open, resolvedYes, resolvedNo }

class Market {
  final String id;
  final String question;
  final String yesLabel;
  final String noLabel;
  final DateTime closeDate;
  final MarketStatus status;

  Market({
    required this.id,
    required this.question,
    required this.yesLabel,
    required this.noLabel,
    required this.closeDate,
    required this.status,
  });

  String get closeDateText =>
      '${closeDate.year.toString().padLeft(4, '0')}-'
      '${closeDate.month.toString().padLeft(2, '0')}-'
      '${closeDate.day.toString().padLeft(2, '0')}';

  String get statusText {
    switch (status) {
      case MarketStatus.open:
        return 'Open';
      case MarketStatus.resolvedYes:
        return 'Resolved: YES';
      case MarketStatus.resolvedNo:
        return 'Resolved: NO';
    }
  }
}

// For now we still keep dummy data in memory.
// Later we will fetch real markets from Canton JSON API.
final List<Market> dummyMarkets = [
  Market(
    id: 'M1',
    question: 'Will BTC be above 100k by 2030-01-01?',
    yesLabel: 'Yes, above 100k',
    noLabel: 'No, below 100k',
    closeDate: DateTime(2030, 1, 1),
    status: MarketStatus.open,
  ),
  Market(
    id: 'M2',
    question: 'Will ETH flip BTC in market cap by 2035?',
    yesLabel: 'Yes',
    noLabel: 'No',
    closeDate: DateTime(2035, 1, 1),
    status: MarketStatus.open,
  ),
];