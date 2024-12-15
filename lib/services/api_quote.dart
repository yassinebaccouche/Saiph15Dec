import 'dart:convert';

import 'package:http/http.dart' as http;

class QuoteService {
  static const apiUrl =
      'https://api.api-ninjas.com/v1/quotes?category=happineess';
  static const apiKey = 'PrDNdxDUHtGnli7ORHmSfA==JdDIbGYNpjrESqIf';

  static Future<String> getQuote() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'X-Api-Key': apiKey,
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data[0]['quote'];
      } else {
        return "Impossible d'obtenir des données";
      }
    } catch (error) {
      return "Impossible d'obtenir des données";
    }
  }
}
