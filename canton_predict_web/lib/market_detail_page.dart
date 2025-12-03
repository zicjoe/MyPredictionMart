import 'package:flutter/material.dart';
import 'market.dart';
import 'services/bet_service.dart';

class MarketDetailPage extends StatefulWidget {
  final Market market;

  const MarketDetailPage({
    super.key,
    required this.market,
  });

  @override
  State<MarketDetailPage> createState() => _MarketDetailPageState();
}

class _MarketDetailPageState extends State<MarketDetailPage> {
  String? _selectedSide; // "YES" or "NO"
  final TextEditingController _stakeController = TextEditingController();

  final BetService _betService = BetService();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _stakeController.dispose();
    super.dispose();
  }

  Future<void> _submitBet() async {
    // Basic validation
    if (_selectedSide == null || _stakeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select YES/NO and enter a stake amount'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await _betService.placeBet(
        marketId: widget.market.id,
        side: _selectedSide!,           // "YES" or "NO"
        amount: _stakeController.text,  // string for now
      );

      final ok = result['ok'] == true;
      final message =
          result['message'] ?? (ok ? 'Bet recorded successfully' : 'Bet failed');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      if (ok) {
        // Optional: clear stake after a successful bet
        _stakeController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing bet: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final market = widget.market;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              market.question,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('YES: ${market.yesLabel}'),
            Text('NO:  ${market.noLabel}'),
            const SizedBox(height: 8),
            Text('Closes: ${market.closeDateText}'),
            Text('Status: ${market.statusText}'),
            const SizedBox(height: 24),

            Text(
              'Place a Bet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // YES / NO toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text('Bet YES'),
                  selected: _selectedSide == 'YES',
                  onSelected: (selected) {
                    setState(() {
                      _selectedSide = selected ? 'YES' : null;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Bet NO'),
                  selected: _selectedSide == 'NO',
                  onSelected: (selected) {
                    setState(() {
                      _selectedSide = selected ? 'NO' : null;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stake input
            TextField(
              controller: _stakeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stake Amount',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitBet,
                child: Text(
                  _isSubmitting ? 'Submitting…' : 'Submit Bet',
                ),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'Later this will send a real request to the Daml JSON API.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}