import 'dart:convert';
import 'package:http/http.dart' as http;

/// This service will eventually talk to the Daml JSON API.
/// For now it assumes:
///   - JSON API running on http://localhost:7575
///   - A template Main:Bet exists on the ledger
///   - You have a JWT token for some party (e.g. "Alice")
class BetService {
  // TODO: change this if your JSON API runs on a different port or host.
  static const String _baseUrl = 'http://localhost:7575';

  // TODO: paste your real JWT token here.
  // Get it from your Daml / Canton setup (Navigator / docs).
  static const String _jwtToken = 'PASTE_YOUR_JWT_TOKEN_HERE';

  Future<Map<String, dynamic>> placeBet({
    required String marketId,
    required String side,   // "YES" or "NO"
    required String amount, // we keep it as string for now
  }) async {
    final uri = Uri.parse('$_baseUrl/v1/create');

    // NOTE: This payload MUST match your real Daml template fields.
    // Adjust the field names to whatever your template Bet actually has.
    final body = {
      "templateId": "Main:Bet",  // change if your module/name differ
      "payload": {
        "marketId": marketId,
        "side": side,
        "amount": amount,
        // Add/remove fields here to match your Daml Bet template.
      }
    };

    final headers = {
      'Content-Type': 'application/json',
      // If your JSON API uses JWT auth:
      'Authorization': 'Bearer $_jwtToken',
    };

    final response =
        await http.post(uri, headers: headers, body: jsonEncode(body));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Expecting JSON back from JSON API
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return {
        "ok": true,
        "message": "Bet recorded on ledger",
        "raw": data,
      };
    } else {
      // Decode error if possible
      String message = 'HTTP ${response.statusCode}';
      try {
        final err = jsonDecode(response.body);
        message = err.toString();
      } catch (_) {}

      return {
        "ok": false,
        "message": "Bet failed: $message",
      };
    }
  }
}