import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

/// Data class representing the connection details needed to join a LiveKit room
class ConnectionDetails {
  final String serverUrl;
  final String roomName;
  final String participantName;
  final String participantToken;

  ConnectionDetails({
    required this.serverUrl,
    required this.roomName,
    required this.participantName,
    required this.participantToken,
  });
}

class TokenService {
  static final _logger = Logger('TokenService');

  // Replace with your LiveKit server URL
  final String liveKitServerUrl = 'wss://test1-8otmz38g.livekit.cloud';

  // Your Node.js API URL
  final String tokenApiUrl = 'https://livekit-token-generation-api-nodejs-2.onrender.com/getToken';

  /// Fetch connection details from your Node.js API
  Future<ConnectionDetails> fetchConnectionDetails({
    required String roomName,
    required String participantName,
  }) async {
    try {
      // Optionally, you can send roomName/participantName as query params
      final uri = Uri.parse(tokenApiUrl).replace(queryParameters: {
        'roomName': roomName,
        'participantName': participantName,
      });

      final response = await http.get(uri);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Altamash"+response.body.trim());
//        final token = response.body.trim();
        final Map<String,dynamic> data= jsonDecode(response.body.trim());
        final token = data['token'];
        return ConnectionDetails(
          serverUrl: liveKitServerUrl,
          roomName: roomName,
          participantName: participantName,
          participantToken: token,
        );
      } else {
        _logger.severe('Failed to get token from API: ${response.statusCode}');
        throw Exception('Failed to get token from API');
      }
    } catch (e) {
      _logger.severe('Error fetching token: $e');
      rethrow;
    }
  }
}
