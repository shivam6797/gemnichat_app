import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemnichat_app/core/error/api_exception.dart';

class ChatApiService {
  final Dio _dio = Dio();
  late final String _apiKey;
  final String _model = 'gemini-1.5-flash';

  ChatApiService() {
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception("🚫 GEMINI_API_KEY not found in .env. Make sure it's loaded before this.");
    }
    _apiKey = key;
  }

  Future<String> sendMessage(String prompt) async {
    try {
      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1/models/$_model:generateContent?key=$_apiKey',
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final candidates = response.data['candidates'];
      if (candidates == null || candidates.isEmpty) {
        throw AppException("Gemini didn't return any candidates.");
      }

      final reply = candidates[0]['content']?['parts']?[0]?['text'];
      if (reply == null || reply.toString().trim().isEmpty) {
        throw AppException("Gemini response was empty.");
      }

      return reply;
    } on DioException catch (dioError) {
      final statusCode = dioError.response?.statusCode;
      if (statusCode != null) {
        throw AppException.fromStatusCode(statusCode);
      } else {
        throw AppException("Network error. Please check your connection.");
      }
    } catch (e) {
      throw AppException("Something went wrong while contacting Gemini.");
    }
  }
}
